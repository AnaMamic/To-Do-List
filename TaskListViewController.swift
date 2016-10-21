//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 19/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK: Properties

    @IBOutlet weak private var taskTableView: UITableView!
    
    var coreDataManager: CoreDataManager?
    var fetchedResultsController: NSFetchedResultsController<Task>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tasks"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector(deleteAll))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewTaskAction))
        
        taskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
        fetchedResultsController = coreDataManager?.fetchedResultsController()
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Task")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        /*
        cell.textLabel?.text = myTasks[indexPath.row].name
        return cell */
        
        if let task = fetchedResultsController?.object(at: indexPath) as Task? {
            cell.textLabel?.text = task.name
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let task = fetchedResultsController?.object(at: indexPath) as Task? {
                fetchedResultsController?.managedObjectContext.delete(task)
                coreDataManager?.saveContext()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = fetchedResultsController?.object(at: indexPath)
        let taskViewController = TaskViewController(nibName: String(describing: TaskViewController.self), bundle: nil)
        taskViewController.coreDataManager = coreDataManager
        taskViewController.mode = .edit
        taskViewController.task = task
        navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            if newIndexPath != nil {
                taskTableView.insertRows(at: [newIndexPath!], with: .fade)
            }
            break
        case .delete:
            if indexPath != nil {
                taskTableView.deleteRows(at: [indexPath!], with: .fade)
            }
            break
        case .update:
            if indexPath != nil {
                taskTableView.reloadRows(at: [indexPath!], with: .fade)
            }
            break
        case .move:
            if indexPath != nil {
                taskTableView.deleteRows(at: [indexPath!], with: .fade)
            }
            
            if newIndexPath != nil {
                taskTableView.insertRows(at: [newIndexPath!], with: .fade)
            }
            break
            
        }
    }

    // MARK: - Navigation
     
     func addNewTaskAction() {
     let taskViewController = TaskViewController(nibName: String(describing: TaskViewController.self), bundle: nil)
     taskViewController.coreDataManager = coreDataManager
     taskViewController.mode = .add
     navigationController?.pushViewController(taskViewController, animated: true)
     }
    
    
    func deleteAll() {
        coreDataManager?.deleteAll()
        coreDataManager?.saveContext()
    }
}
