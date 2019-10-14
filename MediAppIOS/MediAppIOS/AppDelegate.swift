//
//  AppDelegate.swift
//  MediAppIOS
//
//  Created by abhishek on 01/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerContainer: MMDrawerController?
    var locationManager: CLLocationManager?


    func MoveToMain(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

           let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainPageViewController")

              self.window?.rootViewController = initialViewController
              self.window?.makeKeyAndVisible()
       }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
 
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func buildNavigationDrawer(drawer : String)
    {
        switch drawer {
        case "chemist":
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let mainPage:MyTabBarViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MyTabBarViewController") as! MyTabBarViewController
            
            let leftSideMenu:LeftSideViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
            
            let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
            
            drawerContainer = MMDrawerController(center: mainPage, leftDrawerViewController: leftSideMenuNav)
            
            drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            
            // Assign MMDrawerController to our window's root ViewController
            window?.rootViewController = drawerContainer
            
            break
            
        case "stockiest" :
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let mainPage:StockistHomeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "StockistHomeViewController") as! StockistHomeViewController
            
            let leftSideMenu:StockistDrawerController = mainStoryBoard.instantiateViewController(withIdentifier: "StockistDrawerController") as! StockistDrawerController
            
            let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
            
            drawerContainer = MMDrawerController(center: mainPage, leftDrawerViewController: leftSideMenuNav)
            
            drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            
            // Assign MMDrawerController to our window's root ViewController
            window?.rootViewController = drawerContainer
            
            break
            
     
        default:
            break
        }
     
}
}
