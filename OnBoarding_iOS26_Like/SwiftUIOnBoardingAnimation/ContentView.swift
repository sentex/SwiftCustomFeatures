//
//  ContentView.swift
//  SwiftUIOnBoardingAnimation
//
//  Created by ViktorM1Max on 25.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let subtitle = "Introducing a new design with\nLiguid Glass."
        
        iOS26OnBoarding(tint:.blue, hideBezels: false, items: [
            .init(id: 0, title: "Hello", subtitle: subtitle, screenshot: UIImage(named: "Screen1")),
            .init(id: 1, title: "Title 2", subtitle: subtitle, screenshot: UIImage(named: "Screen4")),
            .init(id: 2, title: "Title 3", subtitle: subtitle, screenshot: UIImage(named: "Screen3"), zoomScale: 1.3, zoomAnchor: .bottom),
            .init(id: 3, title: "Title 4", subtitle: subtitle, screenshot: UIImage(named: "Screen2"), zoomScale: 1.5, zoomAnchor: .init(x: 0.5, y: -0.15)),
            .init(id: 4, title: "Welcome to iOS 26", subtitle: subtitle, screenshot: UIImage(named: "Screen")),
        ]) {
            print("Completed")
        }
    }
}

#Preview {
    ContentView()
}
