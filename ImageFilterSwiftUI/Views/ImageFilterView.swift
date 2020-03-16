//
//  FilterView.swift
//  ImageFilterMac
//
//  Created by Alfian Losari on 25/02/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

fileprivate struct CarouselImageFilter: Identifiable {
    
    var id: String {
        filter.rawValue + String(image.hashValue)
    }
    
    var filter: ImageFilter
    var image: CPImage
}

struct CarouselFilterView: View {
    
    let image: CPImage?
    @Binding var filteredImage: CPImage?
    
    fileprivate var imageFilters: [CarouselImageFilter] {
        guard let image = self.image else { return [] }
        return ImageFilter.allCases.map { CarouselImageFilter(filter: $0, image: image) }
    }
    
    var body: some View {
        VStack {
            if image != nil {
                Text("Select Filter")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(imageFilters) { imageFilter in
                            ImageFilterView(observableImageFilter: ImageFilterObservable(image: imageFilter.image, filter: imageFilter.filter), filteredImage: self.$filteredImage)
                                .padding(.leading, 16)
                                .padding(.trailing, self.imageFilters.last!.filter == imageFilter.filter ? 16 : 0)
                        }
        
                    }
                    .frame(height: 140)
                }
            }
        }
    }
}

extension CarouselFilterView: Equatable {

    static func == (lhs: CarouselFilterView, rhs: CarouselFilterView) -> Bool {
        return lhs.image == rhs.image
    }
}


struct ImageFilterView: View {
    
    @ObservedObject var observableImageFilter: ImageFilterObservable
    @Binding var filteredImage: CPImage?
    
    var body: some View {
        VStack {
            ZStack {
                Image(cpImage: observableImageFilter.filteredImage != nil ? observableImageFilter.filteredImage! : observableImageFilter.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .cornerRadius(8)
                
                if observableImageFilter.filteredImage == nil {
                    ProgressView()
                }
            }
            
            Text(observableImageFilter.filter.rawValue)
                .font(.subheadline)
        }
        .onAppear(perform: self.observableImageFilter.filterImage)
        .onTapGesture(perform: handleOnTap)
    }
    
    private func handleOnTap() {
        guard let filteredImage = observableImageFilter.filteredImage else {
            return
        }
        self.filteredImage = filteredImage
    }
}
