//
//  AppDelegate.swift
//  ToDo
//
//  Created by Ana Mamic on 18/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let navigationService = NavigationService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationService.pushInitialScreen(window: window)
        return true
    }
}
