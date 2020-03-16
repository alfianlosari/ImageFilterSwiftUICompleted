//
//  AppState.swift
//  ImageFilterMac
//
//  Created by Alfian Losari on 25/02/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Combine

class AppState: ObservableObject {
    
    static let shared = AppState()
    
    private init() {}
        
    @Published var filteredImage: CPImage?
    @Published var image: CPImage? {
        didSet {
            self.filteredImage = nil
        }
    }
}
