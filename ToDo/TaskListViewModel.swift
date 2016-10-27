//
//  TaskListViewModel.swift
//  ToDo
//
//  Created by Ana Mamic on 25/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData
import UIKit

typealias VoidClosure = () -> ()
typealias TableViewActionHandler = ([IndexPath], UITableViewRowAnimation) -> ()

class TaskListViewModel: NSObject {
    
    // MARK: Properties
    
    private let coreDataManager: CoreDataManager
    private let fetchedResultsController: NSFetchedResultsController<Task>?
    private let navigationService: NavigationService
    fileprivate var beginUpdates: VoidClosure?
    fileprivate var endUpdates: VoidClosure?
    fileprivate var insertRows: TableViewActionHandler?
    fileprivate var deleteRows: TableViewActionHandler?
    fileprivate var reloadRows: TableViewActionHandler?

    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager, navigationService: NavigationService) {
        self.coreDataManager = coreDataManager
        self.navigationService = navigationService
        fetchedResultsController = coreDataManager.fetchedResultsController()
        
    }
    
    // MARK: Methods 
    
    func register(beginUpdates: @escaping VoidClosure, endUpdates: @escaping VoidClosure, insertRows: @escaping TableViewActionHandler, deleteRows: @escaping TableViewActionHandler, reloadRows: @escaping TableViewActionHandler) {
        self.beginUpdates = beginUpdates
        self.endUpdates = endUpdates
        self.insertRows = insertRows
        self.deleteRows = deleteRows
        self.reloadRows = reloadRows
        fetchedResultsController?.delegate = self
    }
    
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
    
    func addNewTask() {
        navigationService.pushTaskScreen(task: nil, mode: .add)
    }
    
    func editTask(indexPath: IndexPath) {
        navigationService.pushTaskScreen(task: task(indexPath: indexPath), mode: .edit)
    }
}

extension TaskListViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        beginUpdates?()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        endUpdates?()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            insertRows?([newIndexPath], .fade)
            break
        case .delete:
            guard let indexPath = indexPath else { return }
            deleteRows?([indexPath], .fade)
            break
        case .update:
            guard let indexPath = indexPath else { return }
            reloadRows?([indexPath], .fade)
            break
        case .move:
            guard let indexPath = indexPath else { return  }
            guard let newIndexPath = newIndexPath else { return }
            deleteRows?([indexPath], .fade)
            insertRows?([newIndexPath], .fade)
            break
        }
    }
    
}
