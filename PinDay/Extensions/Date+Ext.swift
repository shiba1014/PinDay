//
//  Date+Ext.swift
//  PinDay
//
//  Created by shiba on 2021/04/20.
//

import Foundation

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    static func calcProgress(from start: Date, to end: Date, now: Date) -> Double {
        max(min((now - start) / (end - start), 1.0), 0.0)
    }
}

extension Calendar {

    static let gregorian: Calendar = {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.locale = .current
        calendar.timeZone = .current
        return calendar
    }()

    func year(of date: Date) -> Int {
        component(.year, from: date)
    }

    func move(day value: Int, from date: Date) -> Date {
        self.date(byAdding: .day, value: value, to: date)!
    }

    func days(from start: Date, to end: Date) -> Int {
        dateComponents([.day], from: startOfDay(for: start), to: startOfDay(for: end)).day!
    }

    func startOfYear(for date: Date) -> Date {
        let comp = DateComponents(year: year(of: date), month: 1, day: 1)
        return self.date(from: comp)!
    }

    func endOfYear(for date: Date) -> Date {
        let comp = DateComponents(year: 1, day: -1)
        return self.date(byAdding: comp, to: startOfYear(for: date))!
    }

    func oclock(of date: Date) -> Date {
        let comp = dateComponents([.year, .month, .day, .hour], from: date)
        return self.date(from: comp)!
    }
}
