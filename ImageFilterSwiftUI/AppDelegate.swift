//
//  AppDelegate.swift
//  ImageFilterMac
//
//  Created by Alfian Losari on 23/02/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let appState = AppState.shared
        let contentView = ContentView()
            .environmentObject(appState)
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        window.title = "Image Filter"
        window.collectionBehavior = [.fullScreenAuxiliary, .fullScreenNone]
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
