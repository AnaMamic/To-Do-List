//
//  DeleteImageViewModel.swift
//  ToDo
//
//  Created by Ana Mamic on 28/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import UIKit

class DeleteImageViewModel {
    
    // MARK: Properties
    private let navigationService: NavigationService
    let selectedImage: UIImage
    private let indexPath: IndexPath
    
    init(navigationService: NavigationService, selectedImage: UIImage, indexPath: IndexPath) {
        self.navigationService = navigationService
        self.selectedImage = selectedImage
        self.indexPath = indexPath
    }
    
    func deleteImage() {
        if indexPath.row < TaskImagesSingleton.sharedInstance.taskImages.count {
            let deletedImage = TaskImagesSingleton.sharedInstance.taskImages.remove(at: indexPath.row)
            TaskImagesSingleton.sharedInstance.deletedTaskImages.insert(deletedImage)
            
        } else {
          TaskImagesSingleton.sharedInstance.newTaskImagesData.remove(at: indexPath.row - TaskImagesSingleton.sharedInstance.taskImages.count)
        }
        
        TaskImagesSingleton.sharedInstance.imageDeleted = true
        TaskImagesSingleton.sharedInstance.indexOfDeletedImage = indexPath
        
        navigationService.popImageScreen()
    }
}

