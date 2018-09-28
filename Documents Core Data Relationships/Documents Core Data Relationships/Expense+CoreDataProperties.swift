//
//  Expense+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Hayden Harrill on 9/27/18.
//  Copyright © 2018 Hayden Harrill. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var name: String?
    @NSManaged public var rawDate: NSDate?
    @NSManaged public var amount: Double
    @NSManaged public var category: Category?

}
