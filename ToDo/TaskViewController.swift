//
//  TaskViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 19/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var descriptionTextView: UITextView!
    
    var task: Task?
    var coreDataManager: CoreDataManager?
    
    enum Mode {
        case add
        case edit
    }
    
    var mode: Mode?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))

        // Do any additional setup after loading the view.
        
        if let task = task {
            nameTextField.text = task.name
            descriptionTextView.text = task.descriptionOfTask
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    // Hide keyboard when user tap outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func save() {
        
        if (nameTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: "Name must be filled out", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            switch mode! {
            case .add:
                createTask()
            case .edit:
                editTask()
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func createTask() {
        if let taskRecord = coreDataManager?.createRecordForTask(){
            task = taskRecord
            task?.name = nameTextField.text!
            task?.descriptionOfTask = descriptionTextView.text
            task?.createdAt = NSDate().timeIntervalSinceReferenceDate
            coreDataManager?.saveContext()
        }
    }
    
    func editTask() {
        task?.name = nameTextField.text
        task?.descriptionOfTask = descriptionTextView.text
    }

    
}

