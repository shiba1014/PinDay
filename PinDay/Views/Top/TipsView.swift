//
//  TipsView.swift
//  PinDay
//
//  Created by shiba on 2021/05/09.
//

import SwiftUI

struct TipsView: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {

                HStack {
                    Text("Smart Format")
                        .font(.headline)
                    Image(systemName: "lightbulb")
                }
                .padding(.bottom, 2)

                Text("If the lightbulb icon on an event details page is tapped, the number of days will be displayed in a smart format.")
                    .padding(.bottom, 16)

                HStack {
                    Text("Flickering Widgets")
                        .font(.headline)
                    Image(systemName: "exclamationmark.triangle")
                }
                .padding(.bottom, 2)

                Text("Sometimes, the widget may start to flicker if events are updated frequently or too many widgets is added to your home screen. If this issue occurs, please wait a few seconds. You may also troubleshoot this by removing the PinDay widget and adding it again.")
                    .padding(.bottom, 16)

                Spacer()

                Group {
                Image("Logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    Text("Have a lovely day!")
                        .font(.caption)
                        .padding(.top, -8)
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .navigationBarTitle("Tips", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
