//
//  TaskTableViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 18/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var myTasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = myTasks[indexPath.row].name
        return cell
        
        
    }
    


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        myTasks.insert(myTasks[fromIndexPath.row], at: to.row)
        if(to.row < fromIndexPath.row) {
            myTasks.remove(at: fromIndexPath.row - 1)
        } else {
            myTasks.remove(at: fromIndexPath.row)
        }
    
    }
 

    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation
    
    @IBAction func unwindToTaskList (sender: UIStoryboardSegue) {
        if let taskViewController = sender.source as? TaskViewController, let task = taskViewController.task {
            
           if let indexPath  = tableView.indexPathForSelectedRow {
                myTasks[indexPath.row] = task
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
            let indexPath = NSIndexPath(row: myTasks.count, section: 0)
            myTasks += [task]
            tableView.insertRows(at: [indexPath as IndexPath], with: .bottom)
            }
        }
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditTask" {
            let destinationViewController = segue.destination as! UINavigationController
            let taskViewController = destinationViewController.viewControllers[0] as! TaskViewController
            
            if let selectedTaskCell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: selectedTaskCell)!
                let selectedTask = myTasks[indexPath.row]
                taskViewController.task = selectedTask
            }
        }
    }
    

}
