//
//  Task+CoreDataProperties.swift
//  FocusOn
//
//  Created by Ahmad Murad on 01/11/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var caption: String?
    @NSManaged public var completed: Bool
    @NSManaged public var taskNu: Float
    @NSManaged public var goal: Goal?

}
