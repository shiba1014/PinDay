//
//  CreateBackgroundView.swift
//  PinDay
//
//  Created by shiba on 2021/04/23.
//

import SwiftUI

struct CreateBackgroundView: View {

    enum Style: String, CaseIterable, Identifiable {
        var id: Self { self }

        case color = "Color"
        case image = "Image"
    }

    @Environment(\.presentationMode) var presentationMode
    @State private var selectedStyle: Style = .color

    var body: some View {
        NavigationView {
            VStack {
                DayCounterView()
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 100)

                Picker("Style", selection: $selectedStyle) {
                    ForEach(Style.allCases) { style in
                        Text(style.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedStyle == .color {
                    SelectColorView()
                        .padding(.horizontal)
                }

                Spacer()
            }
            .frame(alignment: .topLeading)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct CreateBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBackgroundView()
    }
}
