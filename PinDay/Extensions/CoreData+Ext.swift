//
//  CoreData+Ext.swift
//  PinDay
//
//  Created by shiba on 2021/05/03.
//

import UIKit

extension Data {
    static func encode(color: UIColor) -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        } catch {
            return nil
        }
    }

    static func encode(image: UIImage) -> Data? {
        image.jpegData(compressionQuality: 1.0)
    }
}

extension UIImage {
    static func decode(_ data: Data) -> UIImage? {
        UIImage(data: data)
    }
}

extension UIColor {
    static func decode(_ data: Data) -> UIColor? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}
