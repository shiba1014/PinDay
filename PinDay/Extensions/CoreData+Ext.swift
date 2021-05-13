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

    static func encode(image: UIImage, in mbSize: Double) -> Data? {
        var quality: CGFloat = 1.0
        let minQuality: CGFloat = 0.1

        var data = image.jpegData(compressionQuality: quality)
        while (data?.mbSize ?? 0) > mbSize && quality > minQuality {
            quality -= 0.1
            data = image.jpegData(compressionQuality: quality)
        }
        return data
    }

    var mbSize: Double {
        Double(count) / 1024 / 1024
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
