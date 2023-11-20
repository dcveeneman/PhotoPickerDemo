//
//  ContentView.swift
//  PhotoPickerDemo
//
//  Created by David Veeneman on 11/19/23.
//
//  From "SwiftUI PhotoPicker: A Hands-On Guide with Examples"
//  https://softwareanders.com/swiftui-photopicker-a-hands-on-guide-with-examples/

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State var uiImage: UIImage?
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .any(of: [.images, .not(.livePhotos)]),
                photoLibrary: .shared()) {
                    Text("Select a photo from PhotoPicker")
                }
            
            if uiImage != nil {
                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onChange(of: selectedPhoto) { 
            Task {
                do {
                    if let data = try await selectedPhoto?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            self.uiImage = uiImage
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                    selectedPhoto = nil
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
