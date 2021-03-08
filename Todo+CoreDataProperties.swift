//
//  Todo+CoreDataProperties.swift
//  What To Do
//
//  Created by Rifqi Alfaizi on 07/03/21.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var done: Bool
    @NSManaged public var priority: String?
    @NSManaged public var priorityNumber: Int64
    @NSManaged public var task: String?

}

extension Todo : Identifiable {

}
