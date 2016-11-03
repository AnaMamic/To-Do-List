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
    
    func popScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func pushTaskImagesScreen(taskImages: [Image], newTaskImagesData: [Data], deletedTaskImages: Set<Image>) {
        let taskImagesViewController = TaskImagesViewController(viewModel: TaskImagesViewModel(coreDataManager: coreDataManager, navigationService: self, taskImages: taskImages, newTaskImagesData: newTaskImagesData, deletedTaskImages: deletedTaskImages))
        navigationController.pushViewController(taskImagesViewController, animated: true)
    }
    
    func popTaskImagesScreen(newTaskImagesData: [Data], deletedTaskImages: Set<Image>) {
        guard let taskViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? TaskViewController else {
            return
        }
        
        taskViewController.setupViewModel(newTaskImagesData: newTaskImagesData, deletedTaskImages: deletedTaskImages)
        navigationController.popViewController(animated: true)
    }
    
    func pushImagePickerController(taskImagesViewController: TaskImagesViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = taskImagesViewController
        taskImagesViewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    func dismissImagePickerController(taskImagesViewController: TaskImagesViewController) {
        taskImagesViewController.dismiss(animated: true, completion: nil)
    }
    
    func pushImageScreen(indexPath: IndexPath, selectedImage: UIImage) {
        let deleteImageViewController = DeleteImageViewController(viewModel: DeleteImageViewModel(navigationService: self, selectedImage: selectedImage))
        navigationController.pushViewController(deleteImageViewController, animated: true)
    }
    
    func popImageScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func popDeleteImageScreen() {
        guard let taskImagesViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? TaskImagesViewController else {
            return
        }
        
        taskImagesViewController.deleteImageFromView()
        navigationController.popViewController(animated: true)
    }

}
