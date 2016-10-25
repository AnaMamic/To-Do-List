//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 19/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var taskTableView: UITableView!
    
    var coreDataManager: CoreDataManager
    let fetchedResultsController: NSFetchedResultsController<Task>?
    
    
    // MARK: Initialization
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        fetchedResultsController = self.coreDataManager.fetchedResultsController()
        super.init(nibName: String(describing: TaskListViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        dataFetch()
        
    }
    
    private func viewSetup() {
        title = "Tasks"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector(deleteAll))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewTaskAction))
        taskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    private func dataFetch() {
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Task")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    

    // MARK: - Actions
     
     func addNewTaskAction() {
        let taskViewController = TaskViewController(coreDataManager: coreDataManager, task: nil, mode: .add)
        navigationController?.pushViewController(taskViewController, animated: true)
     }

    func deleteAll() {
        coreDataManager.deleteAllTasks()
        coreDataManager.saveContext()
    }

}

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        if let task = fetchedResultsController?.object(at: indexPath) as Task? {
            cell.textLabel?.text = task.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle != .delete {
            return
        }
        
        guard let task = fetchedResultsController?.object(at: indexPath) as Task? else {
            return
        }
        
        fetchedResultsController?.managedObjectContext.delete(task)
        coreDataManager.saveContext()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = fetchedResultsController?.object(at: indexPath) as Task?
        let taskViewController = TaskViewController(coreDataManager: coreDataManager, task: task, mode: .edit)
        navigationController?.pushViewController(taskViewController, animated: true)
    }
}

extension TaskListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            taskTableView.insertRows(at: [newIndexPath], with: .fade)
            break
        case .delete:
            guard let indexPath = indexPath else { return }
            
            taskTableView.deleteRows(at: [indexPath], with: .fade)
            break
        case .update:
            guard let indexPath = indexPath else { return }

            taskTableView.reloadRows(at: [indexPath], with: .fade)
            break
        case .move:
            guard let indexPath = indexPath else { return  }
            guard let newIndexPath = newIndexPath else { return }
            
            taskTableView.deleteRows(at: [indexPath], with: .fade)
            taskTableView.insertRows(at: [newIndexPath], with: .fade)
            break
        }
    }
}
