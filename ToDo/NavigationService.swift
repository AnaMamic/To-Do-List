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
    
    private let navigationController = UINavigationController()
    private lazy var coreDataManager = CoreDataManager()

    func pushInitialScreen(window: UIWindow?) {
        let taskListViewController = TaskListViewController(viewModel: TaskListViewModel(coreDataManager: coreDataManager, navigationService: self))
        navigationController.setViewControllers([taskListViewController], animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func pushTaskScreen(task: Task?, mode: TaskViewModel.Mode) {
        let taskViewController = TaskViewController(viewModel: TaskViewModel(coreDataManager: coreDataManager, task: task, mode: mode, navigationService: self))
        navigationController.pushViewController(taskViewController, animated: true)
    }
    
    func pushTaskImagesScreen(taskImages: [Image], newTaskImages: [UIImage], addTaskImages: @escaping AddTaskImages, deleteTaskImage: @escaping DeleteTaskImage) {
        let taskImagesViewController = TaskImagesViewController(viewModel: TaskImagesViewModel(coreDataManager: coreDataManager, navigationService: self, taskImages: taskImages, newTaskImages: newTaskImages, addTaskImages: addTaskImages, deleteTaskImage: deleteTaskImage))
        navigationController.pushViewController(taskImagesViewController, animated: true)
    }
    
    func pushImagePickerController(taskImagesViewController: TaskImagesViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = taskImagesViewController
        taskImagesViewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    func pushImageScreen(indexPath: IndexPath, selectedImage: UIImage, closure: @escaping VoidClosure) {
        let deleteImageViewController = DeleteImageViewController(viewModel: DeleteImageViewModel(navigationService: self, selectedImage: selectedImage, closure: closure))
        navigationController.pushViewController(deleteImageViewController, animated: true)
    }

    func popScreen() {
        navigationController.popViewController(animated: true)
    }

    func dismissImagePickerController(taskImagesViewController: TaskImagesViewController) {
        taskImagesViewController.dismiss(animated: true, completion: nil)
    }
}
