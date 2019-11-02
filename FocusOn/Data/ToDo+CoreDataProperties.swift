//
//  ToDo+CoreDataProperties.swift
//  FocusOn
//
//  Created by Ahmad Murad on 02/11/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var caption: String?
    @NSManaged public var cd: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var kind: Bool

}
