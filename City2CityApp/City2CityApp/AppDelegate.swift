//
//  AppDelegate.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         //UINavigationBar.appearance().backIndicatorImage = nil
        //UINavigationBar.appearance().backIndicatorTransitionMaskImage = nil
        //UINavigationBar.appearance().tintColor = UIColor.brandRed
        UITabBar.appearance().tintColor = UIColor.red
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

