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
    private var taskImages: [Image]
    private var newTaskImagesData: [Data]
    private var deletedTaskImages: Set<Image>
    private var selectedIndexPath: IndexPath?
    
    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager, navigationService: NavigationService, taskImages: [Image], newTaskImagesData: [Data], deletedTaskImages: Set<Image>) {
        self.coreDataManager = coreDataManager
        self.navigationService = navigationService
        self.taskImages = taskImages
        self.newTaskImagesData = newTaskImagesData
        self.deletedTaskImages = deletedTaskImages
        setImages()
    }
    
    // MARK: Methods
    
    private func setImages() {
        for taskImage in taskImages {
            guard let image = imageService.getImageFromDocumetsDirectory(name: taskImage.name ?? "")  else {
                return
            }
            images.append(image)
        }
        
        for imageData in newTaskImagesData {
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
        newTaskImagesData.append(selectedImageData)
    }
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func showImage(at: IndexPath) {
        selectedIndexPath = at
        navigationService.pushImageScreen(indexPath: at, selectedImage: images[at.row])
    }
    
    func deleteImage() -> IndexPath? {
        guard let indexPath = selectedIndexPath else {
            return nil
        }
        
        if indexPath.row < taskImages.count {
            let deletedImage = taskImages.remove(at: indexPath.row)
            deletedTaskImages.insert(deletedImage)
            
        } else {
            newTaskImagesData.remove(at: indexPath.row - taskImages.count)
        }
        
        images.remove(at: indexPath.row)
        
        return indexPath
    }
    
    func popTaskImagesViewController() {
        navigationService.popTaskImagesScreen(newTaskImagesData: newTaskImagesData
        , deletedTaskImages: deletedTaskImages)
    }
}
