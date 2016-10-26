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
    
    var task: Task?
    let coreDataManager: CoreDataManager
    let mode: Mode
    enum Mode {
        case add
        case edit
    }
    
    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager, task: Task?, mode: Mode) {
        self.coreDataManager = coreDataManager
        self.task = task
        self.mode = mode
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
    }
    
    func data() -> (String, String)? {
        guard let task = task else {
            return nil
        }
        
        return(task.name ?? "", task.descriptionOfTask ?? "")
    }
}
