//
//  TaskImagesSingleton.swift
//  ToDo
//
//  Created by Ana Mamic on 28/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation

class TaskImagesSingleton {
    
    static let sharedInstance = TaskImagesSingleton()
    
    var taskImages = [Image]()
    var newTaskImagesData = [Data]()
    var deletedTaskImages = Set<Image>()
    var imageDeleted = false
    var indexOfDeletedImage: IndexPath?
    
    init() {
    }
}
