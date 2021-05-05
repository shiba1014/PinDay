//
//  Event+CoreDataProperties.swift
//  PinDay
//
//  Created by shiba on 2021/05/05.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var title: String
    @NSManaged public var pinnedDate: Date
    @NSManaged public var startDate: Date?
    @NSManaged public var backgroundColor: Data?
    @NSManaged public var backgroundImage: Data?

}

extension Event : Identifiable {

}
