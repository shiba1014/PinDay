//
//  CreateBackgroundView.swift
//  PinDay
//
//  Created by shiba on 2021/04/23.
//

import SwiftUI

struct CreateBackgroundView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var draft: EventDraft
    @State private var showPhotoLibrary = false

    var body: some View {
        NavigationView {
            VStack {
                EventSummaryView(draft: draft, size: .small)
                    .padding(.horizontal, 100)

                SelectColorView(
                    selectedColor: .init(
                        get: {
                            if case .color(let color) = draft.backgroundStyle {
                                return color
                            }
                            return nil
                        },
                        set: { color in
                            guard let color = color else { return }
                            draft.backgroundStyle = .color(color)
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
                                draft.backgroundStyle = .image(image)
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
