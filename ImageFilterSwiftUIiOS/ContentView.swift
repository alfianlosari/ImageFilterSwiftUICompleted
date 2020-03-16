//
//  ContentView.swift
//  ImageFilterSwiftUIiOS
//
//  Created by Alfian Losari on 13/03/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State var imagePickerSourceType: UIImagePickerController.SourceType?
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ZStack {
                    if appState.image != nil {
                        Image(cpImage: appState.filteredImage != nil ? appState.filteredImage! : appState.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Text("Add Picture from Photo Library or Camera")
                            .font(.headline)
                            .padding()
                        
                    }
                }
                .padding(.vertical)
                Spacer()
                Divider()
                CarouselFilterView(image: appState.image, filteredImage: self.$appState.filteredImage)
                    .equatable()
            }
                
            .navigationBarItems(leading:
                HStack(spacing: 16) {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Button(action: {
                            self.imagePickerSourceType = .camera
                        }) {
                            Image(systemName: "camera")
                        }
                    }
                    Button(action: {
                        self.imagePickerSourceType = .photoLibrary
                    }) {
                        Image(systemName: "photo")
                    }
                }
                , trailing:
                Button(action: self.shareImage) {
                    Image(systemName: "square.and.arrow.up")
                }
            )
                .navigationBarTitle("Image Filter", displayMode: .inline)
                .sheet(item: self.$imagePickerSourceType) {
                    ImagePicker(image: self.$appState.image, sourceType: $0)
            }
        }
    }
    
    private func shareImage() {
        guard let image = self.appState.filteredImage ?? self.appState.image else {
            return
        }
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
