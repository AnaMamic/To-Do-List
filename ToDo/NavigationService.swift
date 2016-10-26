//
//  NavigationService.swift
//  ToDo
//
//  Created by Ana Mamic on 25/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import UIKit

class NavigationService {
    
    // MARK: Properties
    
    let navigationController = UINavigationController()
    lazy var coreDataManager = CoreDataManager()

    
    func pushInitialScreen(window: UIWindow?) {
        let taskListViewController = TaskListViewController(viewModel: TaskListViewModel(coreDataManager: coreDataManager), navigationService: self)
        navigationController.setViewControllers([taskListViewController], animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func pushTaskScreen(task: Task?, mode: TaskViewModel.Mode) {
        let taskViewController = TaskViewController(viewModel: TaskViewModel(coreDataManager: coreDataManager, task: task, mode: mode), navigationService: self)
        navigationController.pushViewController(taskViewController, animated: true)
    }
    
    func popScreen() {
        navigationController.popViewController(animated: true)
    }
    
    
    
    
    
}
