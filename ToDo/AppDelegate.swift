//
//  AppDelegate.swift
//  ToDo
//
//  Created by Ana Mamic on 18/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataManager = CoreDataManager()
    
   
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let taskListViewController = TaskListViewController(nibName: String(describing: TaskListViewController.self), bundle: nil)
        
        taskListViewController.coreDataManager = coreDataManager
        
        let navigationController = UINavigationController(rootViewController: taskListViewController)
       /* let nekiViewController = NekiViewController(nibName: String(describing: NekiViewController.self), bundle: nil) */
       /* let navigationController = UINavigationController(rootViewController: nekiViewController) */
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    
    
}
