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

    @Binding var backgroundStyle: NewEvent.BackgroundStyle

    @State private var selectedStyle: Style = .color
    @State private var selectedColor: Color?

    init(backgroundStyle: Binding<NewEvent.BackgroundStyle>) {
        self._backgroundStyle = backgroundStyle

        if case .color(let c) = self.backgroundStyle {
            self.selectedColor = c
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                BackgroundView(style: $backgroundStyle)
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
                    SelectColorView(
                        selectedColor: .init(
                            get: { selectedColor },
                            set: { color in
                                guard let color = color else { return }
                                selectedColor = color
                                backgroundStyle = .color(color)
                            }
                        )
                    )
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
        CreateBackgroundView(backgroundStyle: .constant(.color(.gray)))
    }
}
