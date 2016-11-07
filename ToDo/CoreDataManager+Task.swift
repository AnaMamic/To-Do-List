//
//  CoreDataManager+Utilities.swift
//  ToDo
//
//  Created by Ana Mamic on 20/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData
typealias TaskFetchedResultsController = NSFetchedResultsController<Task>

extension CoreDataManager {
    
    func createRecordForTask() -> Task? {
        var task: Task?

        let entity = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext)
        
        if let entity = entity {
            task = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Task
        }
        
        return task
    }
    
    func deleteAllTasks() {
        
        do {
            try persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Task")))
        } catch {
            print("Unable to delete all objects for entity Task")
        }
        
    }
    
    func fetchedResultsController() -> TaskFetchedResultsController? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor] 
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController as? TaskFetchedResultsController
    }
}
