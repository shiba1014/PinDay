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

    var color: Color = .clear
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

    @ViewBuilder
    func buildContentView(size: EventViewSize) -> some View {
        pinnedDate.map { pinnedDate in
            Group {
                if pinnedDate.isFuture() {
                    if let startDate = startDate {
                        CircularDayProgressView(start: startDate, end: pinnedDate, size: size)
                    }
                    else {
                        Text("\(pinnedDate.calcDayDiff()) days left")
                            .font(size.bodyFont)
                            .foregroundColor(.white)
                    }
                }
                else {
                    Text("\(Date().calcDayDiff(from: pinnedDate)) days ago")
                        .font(size.bodyFont)
                        .foregroundColor(.white)
                }
            }
        }
    }
}