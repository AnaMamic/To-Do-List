//
//  Task.swift
//  ToDo
//
//  Created by Ana Mamic on 18/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import UIKit

class Task {
    
    // MARK: Properties
    var name: String
    var description: String?
    var image: UIImage?
    
    // MARK: Initialization
    init? (name: String, description: String?) {
        self.name = name
        self.description = description
        
        if name.isEmpty {
            return nil
        }
    }
    
    
    
    
    
}
