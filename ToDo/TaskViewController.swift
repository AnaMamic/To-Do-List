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
    
    @IBOutlet weak fileprivate var nameTextField: UITextField!
    @IBOutlet weak private var descriptionTextView: UITextView!
    
    fileprivate let viewModel: TaskViewModel
   
    // MARK: Initialization
    
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TaskViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
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
        guard let (name, description) = viewModel.data() else {
            return
        }
        
        nameTextField.text = name
        descriptionTextView.text = description
    }

    func save() {
        
        guard let name = nameTextField.text else {
            return
        }

        if name.isEmpty {
            let alert = UIAlertController(title: "", message: "Name must be filled out", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            viewModel.saveTask(name: name, description: descriptionTextView.text)
        }
    }
    
    @IBAction func imagesButton(_ sender: UIButton) {
        viewModel.presentImages()
    }
    
}

extension TaskViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
