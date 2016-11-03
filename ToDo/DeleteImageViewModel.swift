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
    
    init(navigationService: NavigationService, selectedImage: UIImage) {
        self.navigationService = navigationService
        self.selectedImage = selectedImage
    }
    
    func deleteImage() {
        navigationService.popDeleteImageScreen()
    }
}
