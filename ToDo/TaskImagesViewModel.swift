//
//  TaskImagesViewModel.swift
//  ToDo
//
//  Created by Ana Mamic on 26/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData
import UIKit

typealias AddTaskImages = (UIImage) -> ()
typealias DeleteTaskImage = (Int) -> ()

class TaskImagesViewModel {
    
    // MARK: Properties
    
    private let imageService = ImageService()
    private let coreDataManager: CoreDataManager
    private let navigationService: NavigationService
    private var taskImages: [Image]
    private var newTaskImages: [UIImage]
    private var images = [UIImage]()
    private let addTaskImages: AddTaskImages
    private let deleteTaskImage: DeleteTaskImage
    
    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager, navigationService: NavigationService, taskImages: [Image], newTaskImages: [UIImage], addTaskImages: @escaping AddTaskImages, deleteTaskImage: @escaping DeleteTaskImage) {
        self.coreDataManager = coreDataManager
        self.navigationService = navigationService
        self.taskImages = taskImages
        self.newTaskImages = newTaskImages
        self.addTaskImages = addTaskImages
        self.deleteTaskImage = deleteTaskImage
        
        setImages()
    }
    
    // MARK: Methods

    private func setImages() {
        for taskImage in taskImages {
            guard let image = imageService.getImageFromDocumetsDirectory(name: taskImage.name ?? "") else {
                    return
                }
                
            images.append(image)
        }
        
        images += newTaskImages
        
        print(images.count)
    }
    
    func image(indexPath: IndexPath) -> UIImage {
        return images[indexPath.row]
    }
    
    func presentImagePickerController(taskImagesViewController: TaskImagesViewController) {
        navigationService.pushImagePickerController(taskImagesViewController: taskImagesViewController)
    }
    
    func dismissImagePickerController(taskImagesViewController: TaskImagesViewController, selectedImage: UIImage?) {
        
        navigationService.dismissImagePickerController(taskImagesViewController: taskImagesViewController)
        
        guard let selectedImage = selectedImage else {
            return
        }
        
        addTaskImages(selectedImage)
        images.append(selectedImage)
    }

    func numberOfImages() -> Int {
        return images.count
    }
    
    func showImage(at: IndexPath) {
        navigationService.pushImageScreen(indexPath: at, selectedImage: images[at.row], closure: { [weak self] in self?.deleteImageAt(indexPath: at)})
    }

    func deleteImageAt(indexPath: IndexPath) {
        deleteTaskImage(indexPath.row)
        images.remove(at: indexPath.row)
    }
    
    func popTaskImagesViewController() {
        navigationService.popScreen()
    }
}
