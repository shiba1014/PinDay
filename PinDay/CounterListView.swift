//
//  ContentView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI
import CoreData

struct CounterListView: View {

    let gridItems = [GridItem(), GridItem()]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems) {
                    ForEach(0...6, id: \.self) { _ in
                        DayCounterView()
                            .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding()
                .navigationTitle("Today")
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {}) {
                            Image(systemName: "gearshape.fill")
                        }
                    }

                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                }
            }
        }
        .accentColor(.gray)
    }
}

struct CounterListView_Previews: PreviewProvider {
    static var previews: some View {
        CounterListView().preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
