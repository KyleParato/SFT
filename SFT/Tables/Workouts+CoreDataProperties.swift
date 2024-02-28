//
//  Workouts+CoreDataProperties.swift
//  SFT
//
//  Created by Kyle Parato on 2/27/24.
//
//

import Foundation
import CoreData


extension Workouts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workouts> {
        return NSFetchRequest<Workouts>(entityName: "Workouts")
    }

    @NSManaged public var name: String?

}

extension Workouts : Identifiable {

}
