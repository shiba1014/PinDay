//
//  Date+Ext.swift
//  PinDay
//
//  Created by shiba on 2021/04/20.
//

import Foundation

public extension Calendar {
    static let gregorian = Calendar.init(identifier: .gregorian)
}

public extension Date {
    func beginning() -> Date {
        Calendar.gregorian.startOfDay(for: self)
    }

    func isFuture(than date: Date = .init()) -> Bool {
        Calendar.gregorian.startOfDay(for: self) > Calendar.gregorian.startOfDay(for: date)
    }

    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil) -> Date {
        let calendar = Calendar.gregorian
        var comp = DateComponents()
        comp.year = year ?? calendar.component(.year, from: self)
        comp.month = month ?? calendar.component(.month, from: self)
        comp.day = day ?? calendar.component(.day, from: self)
        return calendar.date(from: comp)!
    }

    func calcDayDiff(from date: Date = .init()) -> Int {
        return Calendar.gregorian.dateComponents([.day], from: date, to: self).day!
    }

    static func calcProgress(from: Date, to: Date) -> Double {
        let whole = to.calcDayDiff(from: from)
        let current = Date().calcDayDiff(from: from)
        return Double(current) / Double(whole)
    }
}
