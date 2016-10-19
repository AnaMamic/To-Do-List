//
//  TaskViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 18/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let task = task {
            nameTextField.text = task.name
            descriptionTextView.text = task.description
        }
         
        nameTextField.delegate = self
        descriptionTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Hide keyboard when user tap outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton === sender as AnyObject? {
            task = Task(name: nameTextField.text ??  "", description: descriptionTextView.text ?? "")
        }
    }
    
    


    


}

