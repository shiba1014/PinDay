//
//  ContentView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI

struct CounterListView: View {
    
    @State private var showCreateView = false
    
    let gridItems = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems) {
                    ForEach(0...6, id: \.self) { _ in
                        DayCounterView.mock
                            .aspectRatio(1, contentMode: .fill)
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            showCreateView.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showCreateView) {
                CreateView()
            }
        }
    }
}

struct CounterListView_Previews: PreviewProvider {
    static var previews: some View {
        CounterListView()
    }
}
