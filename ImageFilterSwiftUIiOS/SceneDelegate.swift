//
//  SceneDelegate.swift
//  ImageFilterSwiftUIiOS
//
//  Created by Alfian Losari on 13/03/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import UIKit
import SwiftUI
import MetalPetal

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let appState = AppState.shared
        let contentView = ContentView()
            .environmentObject(appState)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

