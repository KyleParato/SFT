//
//  Exercise_Time+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 3/1/24.
//
//

import Foundation
import CoreData


extension Exercise_Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise_Time> {
        return NSFetchRequest<Exercise_Time>(entityName: "Exercise_Time")
    }

    @NSManaged public var exercise_name: String?
    @NSManaged public var duration: Date?
    @NSManaged public var timestamp: Date?
    

}

extension Exercise_Time : Identifiable {

}
