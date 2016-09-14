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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 64))
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        FIRApp.configure()
        Fabric.with([Digits.self])
      
        let notificationTypes : UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
        self.createLocalNotification()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: TaskViewController())
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        UINavigationBar.appearance().barTintColor = UIColor(r: 48, g: 140, b: 229)
        application.statusBarStyle = .LightContent
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        
        
        return true
    }
    
    private var digitsAppearance: DGTAppearance {
        let appearance = DGTAppearance()
        appearance.backgroundColor = UIColor.redColor()
        
        return appearance
    }
    
   
    func createLocalNotification() {
        let localNotofication = UILocalNotification()
        localNotofication.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotofication.applicationIconBadgeNumber = 1
        localNotofication.soundName = UILocalNotificationDefaultSoundName
        
        localNotofication.userInfo = [
            "message" : "Check out our new iOS tutorials!"
        ]
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotofication)
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if application.applicationState == .Active {
            // we are inside the app, do sth
        }
        
        self.takeActionWithNotification(notification)
    }
    
    func takeActionWithNotification(localNotification: UILocalNotification) {
//        let notificationMessage = localNotification.userInfo!["message"] as! String
//        let username = "Duc"
//        
//        let alertController = UIAlertController(title: "Hey ", message: notificationMessage, preferredStyle: .Alert)
//        
//        let remindMeLaterAction = UIAlertAction(title: "Remind Me Later", style: .Default, handler: nil)
//        let sureAction = UIAlertAction(title: "Sure", style: .Default) { (action) in
//            print("Hallo")
//        }
//        
//        alertController.addAction(remindMeLaterAction)
//        alertController.addAction(sureAction)
//        
//        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("DEVICE TOKEN = \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        print("MessageID : \(userInfo["gcm_message_id"]!)")
        print(userInfo)
    }

}

