//
//  EventEntity+CoreDataClass.swift
//  PinDay
//
//  Created by shiba on 2021/05/05.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(EventEntity)
public class EventEntity: NSManagedObject {

    var color: Color?
    var image: Image?

    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {

        super.init(entity: entity, insertInto: context)

        if let colorData = backgroundColor,
           let uiColor = UIColor.decode(colorData) {
            color = Color(uiColor)
        }

        if let imageData = backgroundImage,
           let uiImage = UIImage(data: imageData) {
            image = Image(uiImage: uiImage)
        }
    }

    func createDraft() -> EventDraft {

        let draft = EventDraft(
            title: title,
            pinnedDate: pinnedDate,
            startDate: startDate
        )

        if let colorData = backgroundColor,
           let uiColor = UIColor.decode(colorData) {
            draft.backgroundStyle = .color(uiColor)
        }

        if let imageData = backgroundImage,
           let uiImage = UIImage(data: imageData) {
            draft.backgroundStyle = .image(uiImage)
        }

        return draft
    }

    func override(with draft: EventDraft) {
        title = draft.title
        pinnedDate = draft.pinnedDate
        startDate = draft.startDate

        switch draft.backgroundStyle {
        case .color(let color):
            backgroundColor = Data.encode(color: color)
        case .image(let image):
            backgroundImage = Data.encode(image: image)
        }
    }
}
