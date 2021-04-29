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

    @State private var mockEvent: NewEvent = .mock

    @State private var selectedStyle: Style = .color
    @State private var selectedColor: Color?

    @State private var showPhotoLibrary = false
    @State private var selectedImage: UIImage = .init()

    init(backgroundStyle: Binding<NewEvent.BackgroundStyle>) {
        self._backgroundStyle = backgroundStyle

        if case .color(let c) = self.backgroundStyle {
            self.selectedColor = c
        }

        mockEvent.backgroundStyle = self.backgroundStyle
    }

    var body: some View {
        NavigationView {
            VStack {
                DayCounterView(event: mockEvent)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 100)

                if selectedStyle == .color {
                    SelectColorView(
                        selectedColor: .init(
                            get: { selectedColor },
                            set: { color in
                                guard let color = color else { return }
                                selectedColor = color
                                backgroundStyle = .color(color)
                                mockEvent.backgroundStyle = backgroundStyle
                            }
                        )
                    )
                    .padding()
                }

                Button(action: {
                    showPhotoLibrary = true
                }, label: {
                    HStack {
                        Image(systemName: "photo.fill")
                        Text("Select Photo")
                            .font(.headline )
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
                })
                .sheet(isPresented: $showPhotoLibrary) {
                    ImagePicker(
                        selectedImage: .init(
                            get: { selectedImage },
                            set: { image in
                                selectedImage = image
                                backgroundStyle = .image(Image(uiImage: image))
                                mockEvent.backgroundStyle = backgroundStyle
                            }
                        )
                    )
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
