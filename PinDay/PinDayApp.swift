//
//  PinDayApp.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI

@main
struct PinDayApp: App {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .systemBackground
        
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            CounterListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
    }
}
