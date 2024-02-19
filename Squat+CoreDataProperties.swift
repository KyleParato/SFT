//
//  Squat+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 2/17/24.
//
//

import Foundation
import CoreData


extension Squat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Squat> {
        return NSFetchRequest<Squat>(entityName: "Squat")
    }

    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var timestamp: Date?
    @NSManaged public var reps: Int16

}

extension Squat : Identifiable {

}
