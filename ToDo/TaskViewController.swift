//
//  TaskViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 19/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak private var descriptionTextView: UITextView!
    
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
        self.mode = mode
        self.task = task
        super.init(nibName: String(describing: TaskViewController.self), bundle: nil)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    }
    
    private func dataFetch() {
        if let task = task {
            nameTextField.text = task.name
            descriptionTextView.text = task.descriptionOfTask
        }

    }

    func save() {

        if (nameTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: "Name must be filled out", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            switch mode {
            case .add:
                createTask()
            case .edit:
                editTask()
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func createTask() {
        if let taskRecord = coreDataManager.createRecordForTask(){
            task = taskRecord
            task?.name = nameTextField.text!
            task?.descriptionOfTask = descriptionTextView.text
            task?.createdAt = NSDate().timeIntervalSinceReferenceDate
            coreDataManager.saveContext()
        }
    }
    
    func editTask() {
        task?.name = nameTextField.text
        task?.descriptionOfTask = descriptionTextView.text
        coreDataManager.saveContext()
    }
}

extension TaskViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    // Hide keyboard when user tap outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}




