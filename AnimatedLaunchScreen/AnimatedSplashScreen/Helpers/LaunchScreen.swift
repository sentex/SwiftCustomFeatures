//
//  SplashAnimated.swift
//  AnimatedSplashScreen
//
//  Created by ViktorM1Max on 04.08.2026.
//

import SwiftUI

struct LaunchScreen<RootView: View, Logo: View>: Scene {
    var config: LaunchScreenConfig = .init()
    
    @ViewBuilder var logo: () -> Logo
    @ViewBuilder var rootView: RootView
    
    var body: some Scene {
        WindowGroup {
            rootView
                .modifier(LaunchScreenModifier(config: config, logo: logo))
        }
    }
}

fileprivate struct LaunchScreenModifier<Logo: View>: ViewModifier {
    var config: LaunchScreenConfig
    @ViewBuilder var logo: Logo
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var splashWindow: UIWindow?
    
    func body(content: Content) -> some View {
        content
        //Need to use overlay window to fix UI issues
            .onAppear {
                let scenes = UIApplication.shared.connectedScenes
                
                for scene in scenes {
                    guard let windowScene = scene as? UIWindowScene,
                          checkState(windowScene.activationState),
                          // Checking is the Splash window presented on window scene
                          !windowScene.windows.contains(where: {$0.tag == 1009})
                    else {
                        print("Already has a Splash window")
                        continue
                    }
                    
                    // Add Splash window
                    let window = UIWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    let rootViewController = UIHostingController(rootView: LaunchScreenView(config: config) {
                        logo
                    } isCompleted: {
                        window.isHidden = true
                        window.isUserInteractionEnabled = false
                    })
                    rootViewController.view.backgroundColor = .clear
                    window.rootViewController = rootViewController
                    window.tag = 1009
                    self.splashWindow = window
                    
                    print("Splash window added")
                }
            }
    }
    
    private func checkState(_ state: UIWindowScene.ActivationState) -> Bool {
        switch scenePhase {
        case .active:
            return state == .foregroundActive
        case .inactive:
            return state == .foregroundInactive
        case .background:
            return state == .background
        default:
            return state.hashValue == scenePhase.hashValue
        }
    }
}

struct LaunchScreenConfig {
    var initialDelay: Double = 0.35
    var backgroundColor: Color = .black
    var logoBackgroundColor: Color = .white
    var scaling: CGFloat = 4
    var forceHideLogo: Bool = false
    var animation: Animation = .smooth(duration: 1, extraBounce: 0)
}

fileprivate struct LaunchScreenView<Logo: View>: View {
    var config: LaunchScreenConfig
    @ViewBuilder var logo: Logo
    var isCompleted: () -> ()
    
    @State private var scaleDown: Bool = false
    @State private var scaleUp: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(config.backgroundColor)
            .mask {
                GeometryReader {
                    let size = $0.size.applying(.init(scaleX: config.scaling, y: config.scaling))
                    
                    Rectangle()
                        .overlay {
                            logo
                                .blur(radius: config.forceHideLogo ? 0 : (scaleUp ? 15 : 0))
                                .blendMode(.destinationOut)
                                .animation(.smooth(duration: 0.3, extraBounce: 0)) { content in
                                    content
                                        .scaleEffect(self.scaleDown ? 0.8 : 1.0)
                                }
                                .visualEffect { [scaleUp] content, proxy in
                                    let scaleX: CGFloat = size.width / proxy.size.width
                                    let scaleY: CGFloat = size.height / proxy.size.height
                                    
                                    //Logo size scaling
                                    let maxScale: CGFloat = max(scaleX, scaleY)
                                    
                                    return content
                                        .scaleEffect(scaleUp ? maxScale : 1)
                                }
                        }
                }
            }
            .opacity(config.forceHideLogo ? 1 : (scaleUp ? 0 : 1))
            .background {
                Rectangle()
                    .fill(config.logoBackgroundColor)
                    .opacity(scaleUp ? 0 : 1)
            }
            .ignoresSafeArea()
            .task {
                guard !scaleDown else { return }
                try? await Task.sleep(for: .seconds(config.initialDelay))
                scaleDown = true
                try? await Task.sleep(for: .seconds(0.1))
                withAnimation(config.animation, completionCriteria: .logicallyComplete) {
                    scaleUp = true
                } completion: {
                    isCompleted()
                }
                
            }
    }
}
