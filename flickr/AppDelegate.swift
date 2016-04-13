//
//  AppDelegate.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: RootViewController())
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }


}

