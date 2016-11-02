//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Ana Mamic on 25/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData

class TaskViewModel {
    
    // MARK: Properties
    
    private var task: Task?
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

        TaskImagesSingleton.sharedInstance.newTaskImagesData = [Data]()
        TaskImagesSingleton.sharedInstance.deletedTaskImages = Set<Image>()
        
        guard let taskImages = task?.images as? Set<Image> else {
            return
        }
        print(taskImages.count)
        TaskImagesSingleton.sharedInstance.taskImages = Array(taskImages)
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
         task?.removeFromImages(NSSet(set: TaskImagesSingleton.sharedInstance.deletedTaskImages))
        coreDataManager.saveContext()
        navigationService.popScreen()
    }
    
    private func saveTaskImages() {
        for imageData in TaskImagesSingleton.sharedInstance.newTaskImagesData {
            if let image = coreDataManager.createRecordForImage() {
                let imageName = String(NSDate().timeIntervalSince1970)
                image.name = imageName
                imageService.saveImageToDocumentsDirectory(name: imageName, imageData: imageData)
                task?.addToImages(image)
            }

        }
    }
    
    func data() -> (String, String)? {
        guard let task = task else {
            return nil
        }
        return(task.name ?? "", task.descriptionOfTask ?? "")
    }
    
    func presentImages() {
        navigationService.pushTaskImagesScreen()
    }
    
}
