//
//  Exercise_Static+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 2/27/24.
//
//

import Foundation
import CoreData


extension Exercise_Static {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise_Static> {
        return NSFetchRequest<Exercise_Static>(entityName: "Exercise_Static")
    }

    @NSManaged public var reps: Int16
    @NSManaged public var weight: Float
    @NSManaged public var exercise_name: String?
    @NSManaged public var timestamp: Date?

}

extension Exercise_Static : Identifiable {

}
