//
//  Image+CoreDataProperties.swift
//  ToDo
//
//  Created by Ana Mamic on 27/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData

extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var name: String?
    @NSManaged public var task: Task?

}
