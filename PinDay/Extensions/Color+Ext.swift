//
//  Color+Ext.swift
//  PinDay
//
//  Created by shiba on 2021/05/03.
//

import SwiftUI

extension Color {
    static func decode(_ data: Data) -> Color? {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
            return Color(uiColor)
        }
        return nil
    }
}
