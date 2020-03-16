//
//  ProgressView.swift
//  ImageFilterMac
//
//  Created by Alfian Losari on 25/02/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

#if os(iOS)
import UIKit
struct ProgressView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ProgressView>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ProgressView>) {
        uiView.startAnimating()
    }
    
}

#elseif os(OSX)
import AppKit
struct ProgressView: NSViewRepresentable {
    
    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ProgressView>) {
        nsView.style = .spinning
        nsView.startAnimation(self)
    }
    
    func makeNSView(context: NSViewRepresentableContext<ProgressView>) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        return progressIndicator
    }
}
#endif
