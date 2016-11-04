//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Ana Mamic on 25/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol TaskViewModelDelegate {
    func addedNewImages(newImagesData: [Data])
}

class TaskViewModel {
    
    // MARK: Properties
    
    private var task: Task?
    private var taskImages = [Image]()
    private var newTaskImages = [UIImage]()
    private var deletedTaskImages = Set<Image>()
    private let coreDataManager: CoreDataManager
    private let navigationService: NavigationService
    private let imageService = ImageService()
    private let mode: Mode
    enum Mode {
        case add
        case edit
    }
    
    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager, task: Task?, mode: Mode, navigationService: NavigationService) {
        self.coreDataManager = coreDataManager
        self.task = task
        self.mode = mode
        self.navigationService = navigationService
        
        guard let taskImages = task?.images as? Set<Image> else {
            return
        }
        
        self.taskImages = Array(taskImages)
    }
    
    
    // MARK: Methods
    func saveTask(name: String, description: String?) {
        if mode == .add {
            task = coreDataManager.createRecordForTask()
            task?.createdAt = NSDate().timeIntervalSinceReferenceDate
        }
        
        task?.name = name
        task?.descriptionOfTask = description
        saveTaskImages()
        task?.removeFromImages(NSSet(set: deletedTaskImages))
        coreDataManager.saveContext()
        navigationService.popScreen()
    }
    
    private func saveTaskImages() {
        for newImage in newTaskImages {
            
            guard let image = coreDataManager.createRecordForImage(), let imageData = UIImagePNGRepresentation(newImage) else {
                return
            }
            
            let imageName = String(NSDate().timeIntervalSince1970)
            image.name = imageName
            imageService.saveImageToDocumentsDirectory(name: imageName, imageData: imageData)
            task?.addToImages(image)
        }
    }
    
    func deleteTaskImageAt(index: Int) {
        if index < taskImages.count {
            let deletedImage = taskImages.remove(at: index)
            deletedTaskImages.insert(deletedImage)
            
        } else {
            newTaskImages.remove(at: index - taskImages.count)
        }
    }
    
    func data() -> (String, String)? {
        guard let task = task else {
            return nil
        }
        return(task.name ?? "", task.descriptionOfTask ?? "")
    }
    
    func presentImages() {
        navigationService.pushTaskImagesScreen(taskImages: taskImages, newTaskImages: newTaskImages, addTaskImages: { [weak self] in self?.newTaskImages.append($0)}, deleteTaskImage: { [weak self] in self?.deleteTaskImageAt(index: $0) })
    }
}
