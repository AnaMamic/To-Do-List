//
//  CoreDataManager+Image.swift
//  ToDo
//
//  Created by Ana Mamic on 27/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataManager {
    func createRecordForImage() -> Image? {
        var image: Image?
        
        let entity = NSEntityDescription.entity(forEntityName: "Image", in: persistentContainer.viewContext)
        
        if let entity = entity {
            image = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Image
        }
        
        return image
    }
}
