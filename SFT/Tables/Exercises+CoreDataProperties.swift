//
//  Exercises+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 3/1/24.
//
//

import Foundation
import CoreData


extension Exercises {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercises> {
        return NSFetchRequest<Exercises>(entityName: "Exercises")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: Int16
    @NSManaged public var workout_name: String?

}

extension Exercises : Identifiable {

}
