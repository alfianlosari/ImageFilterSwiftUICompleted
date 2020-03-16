//
//  ImageFilterObervable.swift
//  ImageFilterMac
//
//  Created by Alfian Losari on 25/02/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Combine

class ImageFilterObservable: ObservableObject {
    
    @Published var filteredImage: CPImage? = nil

    let image: CPImage
    let filter: ImageFilter
    
    init(image: CPImage, filter: ImageFilter) {
        self.image = image
        self.filter = filter
    }
    
    func filterImage() {
        self.filter.performFilter(with: self.image) {
            self.filteredImage = $0
        }
    }
}
