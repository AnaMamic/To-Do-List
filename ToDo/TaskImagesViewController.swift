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
    
    let navigationService: NavigationService
    var images = [UIImage]()
    
    // MARK: Initialization
    
    init(navigationService: NavigationService) {
        self.navigationService = navigationService
        super.init(nibName: String(describing: TaskImagesViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
    }
    
    func viewSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewImage))
        //taskCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "TaskImageCell")
        taskCollectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        taskCollectionView.register(UINib(nibName: "TaskImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaskImageCell")
        taskCollectionView.register(TaskImageCollectionViewCell.self, forCellWithReuseIdentifier: "TaskImageCell")
           }

    
    func addNewImage() {
        navigationService.pushImagePickerController(taskImagesViewController: self)
    }
}

extension TaskImagesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskImageCell", for: indexPath) as! TaskImageCollectionViewCell
        
        
        print("Naslo sliku")
        
        let slika = images[indexPath.row]
        print(slika)
        cell.imageView = UIImageView()
        cell.imageView = slika
        cell.backgroundColor = UIColor.black
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
    
}

extension TaskImagesViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        images.append(selectedImage)
        print(images.count)
        navigationService.dismissImagePickerController(taskImagesViewController: self)
        taskCollectionView.reloadData()
    }
}

extension TaskImagesViewController: UINavigationControllerDelegate {
    
}






