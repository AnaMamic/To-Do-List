//
//  TaskImagesViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 26/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit

class TaskImagesViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var taskCollectionView: UICollectionView!
    
    fileprivate let viewModel: TaskImagesViewModel
    
    // MARK: Initialization
    
    init(viewModel: TaskImagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TaskImagesViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.imageDeleted() {
            guard let indexPath = viewModel.indexPathOfDeletedImage() else {
                return
            }
            taskCollectionView.deleteItems(at: [indexPath])
        }
    }
    
    func viewSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewImage))
        taskCollectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        
        taskCollectionView.register(UINib(nibName: "TaskImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaskImageCell")
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
}

extension TaskImagesViewController: UINavigationControllerDelegate {
    
}






