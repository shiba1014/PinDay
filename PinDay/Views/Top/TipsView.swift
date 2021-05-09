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

                Text("At an event detail page, You can change a format for duration to smart one by tapping lightbulb button.")
                    .padding(.bottom, 16)

                HStack {
                    Text("Flickering widget issue")
                        .font(.headline)
                    Image(systemName: "cloud.bolt")
                }
                .padding(.bottom, 2)

                Text("After updating events, sometimes your widgets start flickering. If this issue occur, please remove Pinday's widget and add it again.")
                    .padding(.bottom, 16)

                Spacer()

                Group {
                Image("Logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    Text("Have a nice day!")
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
