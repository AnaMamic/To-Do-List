//
//  Task+CoreDataProperties.swift
//  ToDo
//
//  Created by Ana Mamic on 27/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var createdAt: TimeInterval
    @NSManaged public var descriptionOfTask: String?
    @NSManaged public var name: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Task {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
