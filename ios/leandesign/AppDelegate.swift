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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 64))
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
     


        FIRApp.configure()
        Fabric.with([Digits.self])
      

        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: TasksListController())
        
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


}

