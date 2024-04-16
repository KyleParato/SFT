//
//  Exercise_Static+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 3/1/24.
//
//

import Foundation
import CoreData


extension Exercise_Static {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise_Static> {
        return NSFetchRequest<Exercise_Static>(entityName: "Exercise_Static")
    }

    @NSManaged public var exercise_name: String?
    // Gathered from user input
    @NSManaged public var reps: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var weight: Double

}

extension Exercise_Static : Identifiable {

}
