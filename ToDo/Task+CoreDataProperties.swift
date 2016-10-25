//
//  Task+CoreDataProperties.swift
//  ToDo
//
//  Created by Ana Mamic on 21/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var descriptionOfTask: String?
    @NSManaged public var name: String?
    @NSManaged public var createdAt: TimeInterval

}
