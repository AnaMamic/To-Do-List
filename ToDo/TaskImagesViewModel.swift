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

class TaskImagesViewModel {
    
    // MARK: Properties
    
    private let imageService = ImageService()
    private let coreDataManager: CoreDataManager
    private let navigationService: NavigationService
    private var images = [UIImage]()
    
    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager, navigationService: NavigationService) {
        self.coreDataManager = coreDataManager
        self.navigationService = navigationService
        setImages()
    }
    
    // MARK: Methods
    
    private func setImages() {
        for taskImage in TaskImagesSingleton.sharedInstance.taskImages {
            guard let image = imageService.getImageFromDocumetsDirectory(name: taskImage.name ?? "")  else {
                return
            }
            images.append(image)
        }
        
        for imageData in TaskImagesSingleton.sharedInstance.newTaskImagesData {
            guard let image = UIImage(data: imageData)  else {
                return
            }
            images.append(image)
        }
    }

    func image(indexPath: IndexPath) -> UIImage {
        return images[indexPath.row]
    }
    
    func presentImagePickerController(taskImagesViewController: TaskImagesViewController) {
        navigationService.pushImagePickerController(taskImagesViewController: taskImagesViewController)
    }
    
    func dismissImagePickerController(taskImagesViewController: TaskImagesViewController, selectedImage: UIImage) {
        
        navigationService.dismissImagePickerController(taskImagesViewController: taskImagesViewController)
        
        guard let selectedImageData = UIImagePNGRepresentation(selectedImage) else {
            return
        }
        
        images.append(selectedImage)
        TaskImagesSingleton.sharedInstance.newTaskImagesData.append(selectedImageData)
    }
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func showImage(at: IndexPath) {
        navigationService.pushImageScreen(indexPath: at, selectedImage: images[at.row])
    }
    
    func imageDeleted() -> Bool {
        if TaskImagesSingleton.sharedInstance.imageDeleted {
            TaskImagesSingleton.sharedInstance.imageDeleted = false
            return true
        } else {
            return false
        }
    }
    
    func indexPathOfDeletedImage() -> IndexPath? {
        guard let indexPath = TaskImagesSingleton.sharedInstance.indexOfDeletedImage else {
            return nil
        }
        
        images.remove(at: indexPath.row)
        return indexPath
    }
}

