//
//  Todo+CoreDataProperties.swift
//  What To Do
//
//  Created by Rifqi Alfaizi on 28/02/21.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var priority: String?
    @NSManaged public var task: String?
    @NSManaged public var done: Bool

}

extension Todo : Identifiable {

}
