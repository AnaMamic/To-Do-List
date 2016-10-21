//
//  CoreDataManager+Utilities.swift
//  ToDo
//
//  Created by Ana Mamic on 20/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataManager {
    
    
    func createRecordForTask() -> Task? {
        var result: Task? = nil
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? Task
        }
        
        return result
    }
    
    
    
    func fetchRecordsForTask() -> [Task] {
        // Create Fetch Request
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        
        // Helpers
        var result = [Task]()
        
        do {
            // Execute Fetch Request
            let records = try persistentContainer.viewContext.fetch(fetchRequest)
            
            if let records = records as? [Task] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity Task.")
        }
        
        return result
    }
    
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            print("Unable to delete all objects for entity Task")
        }
        
        
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<Task>? {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor] 
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController as? NSFetchedResultsController<Task>
    }
    
    
    
    
}

