//
//  EventEntity+CoreDataProperties.swift
//  PinDay
//
//  Created by shiba on 2021/05/05.
//
//

import Foundation
import CoreData


extension EventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }

    @NSManaged public var backgroundColor: Data?
    @NSManaged public var backgroundImage: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var pinnedDate: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?

}

extension EventEntity : Identifiable {

}
