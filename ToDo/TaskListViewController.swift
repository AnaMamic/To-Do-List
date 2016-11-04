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

    @IBOutlet weak fileprivate var taskTableView: UITableView!
    
    fileprivate let viewModel: TaskListViewModel

    // MARK: Initialization
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TaskListViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        dataSetup()
    }
    
    private func viewSetup() {
        title = "Tasks"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector(deleteAll))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewTaskAction))
        taskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    private func dataSetup() {
        
        viewModel.register(beginUpdates: { self.taskTableView.beginUpdates()}, endUpdates: {self.taskTableView.endUpdates()}, insertRows: {(indexPath, animation) in self.taskTableView.insertRows(at: indexPath, with: animation)}, deleteRows: {(indexPath, animation) in self.taskTableView.deleteRows(at: indexPath, with: animation)}, reloadRows: {(indexPath, animation) in self.taskTableView.reloadRows(at: indexPath, with: animation)})
        viewModel.dataFetch()
    }
    
    // MARK: - Actions
     
     func addNewTaskAction() {
        viewModel.addNewTask()
     }
    
    func deleteAll() {
        viewModel.deleteAllTasks()
    }
}

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfObjects(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        if let taskName = viewModel.taskName(indexPath: indexPath) {
            cell.textLabel?.text = taskName
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
        
        viewModel.deleteTask(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.editTask(indexPath: indexPath)
    }
}


