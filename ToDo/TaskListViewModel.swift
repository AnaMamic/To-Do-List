//
//  TaskListViewModel.swift
//  ToDo
//
//  Created by Ana Mamic on 25/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData

class TaskListViewModel {
    
    // MARK: Properties
    
    let coreDataManager: CoreDataManager
    let fetchedResultsController: NSFetchedResultsController<Task>?

    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        fetchedResultsController = self.coreDataManager.fetchedResultsController()
    }
    
    // MARK: Methods 
    
    func dataFetch() {
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to fetch Task")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }

    func deleteTask(indexPath: IndexPath) {
        guard let task = task(indexPath: indexPath) else {
            return
        }
        
        fetchedResultsController?.managedObjectContext.delete(task)
        coreDataManager.saveContext()
    }
    
    func deleteAllTasks() {
        coreDataManager.deleteAllTasks()
        coreDataManager.saveContext()
    }
    
    func task(indexPath: IndexPath) -> Task? {
        return fetchedResultsController?.object(at: indexPath) as Task? 
    }
    
    func taskName(indexPath: IndexPath) -> String? {
        guard let task = task(indexPath: indexPath) else {
            return nil
        }
        
        return task.name
    }
    
    func numberOfObjects(section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
}
