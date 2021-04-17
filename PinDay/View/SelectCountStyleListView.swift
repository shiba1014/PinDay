//
//  SelectCountStyleListView.swift
//  PinDay
//
//  Created by shiba on 2021/04/18.
//

import SwiftUI

struct SelectCountStyleListView: View {
    

    var body: some View {
        VStack(spacing: 24) {
            Text("Count up")
            Text("Count down")
            Text("Progress")
        }
        .padding()
        .navigationBarTitle("Count Style", displayMode: .inline)
    }
}

struct SelectCountStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountStyleListView()
    }
}

