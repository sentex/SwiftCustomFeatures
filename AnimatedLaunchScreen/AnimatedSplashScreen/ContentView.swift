//
//  ContentView.swift
//  AnimatedSplashScreen
//
//  Created by ViktorM1Max on 04.08.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Animated Splash Screen!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
