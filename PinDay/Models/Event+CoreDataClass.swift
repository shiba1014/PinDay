//
//  Event+CoreDataClass.swift
//  PinDay
//
//  Created by shiba on 2021/05/05.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Event)
public class Event: NSManagedObject {

    private var cachedColor: Color?
    private var cachedImage: Image?

    var color: Color? {
        if let color = cachedColor {
            return color
        }
        if let colorData = backgroundColor,
           let uiColor = UIColor.decode(colorData) {
            cachedColor = Color(uiColor)
            cachedImage = nil
        }
        return cachedColor
    }

    var image: Image? {
        if let image = cachedImage {
            return image
        }
        if let imageData = backgroundImage,
           let image = UIImage.decode(imageData) {
            cachedColor = nil
            cachedImage = Image(uiImage: image)
        }
        return cachedImage
    }
}
