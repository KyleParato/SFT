//
//  Bench+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 2/17/24.
//
//

import Foundation
import CoreData


extension Bench {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bench> {
        return NSFetchRequest<Bench>(entityName: "Bench")
    }

    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var timestamp: Date?
    @NSManaged public var reps: Int16

}

extension Bench : Identifiable {

}
