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
    }
    
    // MARK: Methods
    
    func saveTask(name: String, description: String?) {
        if mode == .add {
            task = coreDataManager.createRecordForTask()
            task?.createdAt = NSDate().timeIntervalSinceReferenceDate
        }
        
        task?.name = name
        task?.descriptionOfTask = description
        coreDataManager.saveContext()
        navigationService.popScreen()
    }
    
    func data() -> (String, String)? {
        guard let task = task else {
            return nil
        }
        
        return(task.name ?? "", task.descriptionOfTask ?? "")
    }
}
