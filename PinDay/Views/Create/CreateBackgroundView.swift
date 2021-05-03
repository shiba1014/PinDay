//
//  CreateBackgroundView.swift
//  PinDay
//
//  Created by shiba on 2021/04/23.
//

import SwiftUI

struct CreateBackgroundView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var event: Event
    @State private var showPhotoLibrary = false

    var body: some View {
        NavigationView {
            VStack {
                EventSummaryView(event: event, size: .small)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 100)

                SelectColorView(
                    selectedColor: .init(
                        get: {
                            if case .color(let color) = event.backgroundStyle {
                                return Color(color)
                            }
                            return nil
                        },
                        set: { color in
                            guard let color = color else { return }
                            event.backgroundStyle = .color(UIColor(color))
                        }
                    )
                )
                .padding()

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
                            get: { .init() },
                            set: { image in
                                event.backgroundStyle = .image(image)
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
        CreateBackgroundView(event: .countDownMock)
    }
}
