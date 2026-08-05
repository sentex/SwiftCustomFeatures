//
//  AnimatedSplashScreenApp.swift
//  AnimatedSplashScreen
//
//  Created by ViktorM1Max on 04.08.2026.
//

import SwiftUI

@main
struct AnimatedSplashScreenApp: App {
    var body: some Scene {
        LaunchScreen(config: .init(forceHideLogo: false)) {
            Image(.appleWhite)
        } rootView: {
            ContentView()
        }
        
//        LaunchScreen(config: .init(forceHideLogo: false)) {
//            Image(systemName: "macpro.gen1.fill")
//                .font(.system(size: 100))
//        } rootView: {
//            ContentView()
//        }
    }
}
