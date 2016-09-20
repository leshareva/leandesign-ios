//
//  AppDelegate.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 8/9/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit
import Firebase
import FirebaseMessaging 


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    
    // Application started
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let pushNotificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        Fabric.with([Digits.self])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tokenRefreshNotification:", name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: TaskViewController())
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        UINavigationBar.appearance().barTintColor = UIColor(r: 48, g: 140, b: 229)
        application.statusBarStyle = .LightContent
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        return true
    }
    
    
    
    
    // Handle refresh notification token
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        
        guard let userId = Digits.sharedInstance().session()?.userID as String! else {
            return
        }
        let ref = FIRDatabase.database().reference().child("clients")
        let values : [String : AnyObject] = ["userToken" : refreshedToken!]
        ref.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err)
                return
            }
        }
       
        // Connect to FCM since connection may have failed when attempted before having a token.
        if (refreshedToken != nil)
        {
            connectToFcm()
            
            FIRMessaging.messaging().subscribeToTopic("/topics/topic")
        }
        
    }
    
    
    // Connect to FCM
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    
    // Handle notification when the application is in foreground
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"])")
       
        // Print full message.
        print("%@", userInfo)
    }
    
    
    // Application will enter in background
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    
        // Application entered in background
        func applicationDidEnterBackground(application: UIApplication)
        {
//            FIRMessaging.messaging().disconnect()
//            print("Disconnected from FCM.")
            
            let refreshedToken = FIRInstanceID.instanceID().token()
            if (refreshedToken != nil)
            {
                connectToFcm()
                
                FIRMessaging.messaging().subscribeToTopic("/topics/topic")
            }

        }
    
    
    
    // Application will enter in foreground
    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    
    
    // Application entered in foreground
    func applicationDidBecomeActive(application: UIApplication)
    {
        connectToFcm()
        
        application.applicationIconBadgeNumber = 0;
    }
    
    
    
    // Application will terminate
    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

