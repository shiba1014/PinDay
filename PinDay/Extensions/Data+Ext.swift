//
//  Data+Ext.swift
//  PinDay
//
//  Created by shiba on 2021/05/03.
//

import SwiftUI

extension Data {
    static func encode(_ color: Color) -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
        } catch {
            return nil
        }
    }
}
