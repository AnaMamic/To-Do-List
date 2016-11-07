//
//  TaskImagesViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 26/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit

class TaskImagesViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var taskCollectionView: UICollectionView!
    
    fileprivate let viewModel: TaskImagesViewModel
    
    // MARK: Initialization
    
    init(viewModel: TaskImagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TaskImagesViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskCollectionView.reloadData()
    }

    func viewSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .bordered, target: self, action: #selector(backTapped))
        taskCollectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        taskCollectionView.register(UINib(nibName: "TaskImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaskImageCell")
    }
    func backTapped() {
        viewModel.popTaskImagesViewController()
    }
    func addNewImage() {
        viewModel.presentImagePickerController(taskImagesViewController: self)
    }
}

extension TaskImagesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskImageCell", for: indexPath) as! TaskImageCollectionViewCell
        
        cell.imageView.image = viewModel.image(indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let size = (UIScreen.main.bounds.width - 30) / 3
        return CGSize(width: size, height: size)
    }
    
}

extension TaskImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showImage(at: indexPath)
    }
}

extension TaskImagesViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        viewModel.dismissImagePickerController(taskImagesViewController: self, selectedImage: info[UIImagePickerControllerOriginalImage] as! UIImage)
        taskCollectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewModel.dismissImagePickerController(taskImagesViewController: self, selectedImage: nil)
    }
}
