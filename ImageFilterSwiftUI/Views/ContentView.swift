//
//  ContentView.swift
//  ImageFilterMac
//
//  Created by Alfian Losari on 23/02/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            InputView(image: self.$appState.image, filteredImage: appState.filteredImage)
            Divider()
            CarouselFilterView(image: appState.image, filteredImage: self.$appState.filteredImage)
            .equatable()
            
            Spacer()
        }
        .padding(.top, 32)
        .padding(.bottom, 16)
        .frame(minWidth: 768, idealWidth: 768, maxWidth: 1024, minHeight: 648, maxHeight: 648)
    }
}

struct InputView: View {
    
    @Binding var image: NSImage?
    let filteredImage: NSImage?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Input image")
                    .font(.headline)
                Button(action: selectFile) {
                    Text("Select image")
                }
            }
            InputImageView(image: self.$image, filteredImage: filteredImage)
            if image != nil {
                Button(action: saveToFile) {
                    Text("Save image")
                }
            }
        }
    }
    
    private func selectFile() {
        NSOpenPanel.openImage { (result) in
            if case let .success(image) = result {
                self.image = image
            }
        }
    }
    
    private func saveToFile() {
        guard let image = filteredImage ?? image else {
            return
        }
        NSSavePanel.saveImage(image, completion: { _ in  })
    }
}

struct InputImageView: View {
    
    @Binding var image: NSImage?
    let filteredImage: NSImage?
        
    var body: some View {
        ZStack {
            if image != nil {
                Image(nsImage: filteredImage != nil ? filteredImage! : image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Drag and drop image file")
                    .frame(width: 320)
            }
        }
        .frame(height: 320)
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
            
        .onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
    }
        
    private func handleOnDrop(providers: [NSItemProvider]) -> Bool {
        if let item = providers.first {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data {
                        let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                        guard let image = NSImage(contentsOf: url) else {
                            return
                        }
                        self.image = image
                    }
                }
            }
            return true
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
