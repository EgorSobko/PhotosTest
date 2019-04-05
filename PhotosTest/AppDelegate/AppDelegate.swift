//
//  AppDelegate.swift
//  PhotosTest
//
//  Created by Egor Sobko on 4/4/19.
//  Copyright © 2019 Egor Sobko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if window == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        PhotosListRouter().execute(in: window)
        
        return true
    }
}
