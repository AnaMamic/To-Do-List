//
//  DeleteImageViewController.swift
//  ToDo
//
//  Created by Ana Mamic on 28/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit

class DeleteImageViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak private var imageView: UIImageView!
    
    private let viewModel: DeleteImageViewModel

    init(viewModel: DeleteImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DeleteImageViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("#function has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = viewModel.selectedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteImageTap))
    }
    
    func deleteImageTap() {
        viewModel.deleteImage()
    }
}
