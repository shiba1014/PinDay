//
//  PinDayApp.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI

@main
struct PinDayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CounterListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
