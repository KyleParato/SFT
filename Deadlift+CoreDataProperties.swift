//
//  Deadlift+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 2/17/24.
//
//

import Foundation
import CoreData


extension Deadlift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deadlift> {
        return NSFetchRequest<Deadlift>(entityName: "Deadlift")
    }

    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var timestamp: Date?
    @NSManaged public var reps: Int16

}

extension Deadlift : Identifiable {

}
