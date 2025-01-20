//
//  WebkitSampleApp.swift
//  WebkitSample
//
//  Created by Luis Alejandro Ramirez Suarez on 20/01/25.
//

import SwiftUI
import WebKit

@main
struct WebKitSampleApp: App {
    @State private var canGoBack = false
    @State private var canGoForward = false
    private let initialURL = URL(string: "https://example.com")!
    
    var body: some Scene {
        WindowGroup {
            VStack {
                NavigationView {
                    ContentView(canGoBack: $canGoBack, canGoForward: $canGoForward, url: initialURL)
                }
                .navigationBarTitle("WebView", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: goBack) {
                            Image(systemName: "arrow.left")
                        }
                        .disabled(!canGoBack)
                        
                        Button(action: goForward) {
                            Image(systemName: "arrow.right")
                        }
                        .disabled(!canGoForward)
                    }
                }
            }
        }
    }
    
    private func goBack() {
        let keyWindow = UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        
        if let webView = findWebView(in: keyWindow) {
            webView.goBack()
        }
    }
    
    private func goForward() {
        let keyWindow = UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        
        if let webView = findWebView(in: keyWindow) {
            webView.goForward()
        }
    }
    
    private func findWebView(in view: UIView?) -> WKWebView? {
        if let webView = view as? WKWebView {
            return webView
        }
        for subview in view?.subviews ?? [] {
            if let found = findWebView(in: subview) {
                return found
            }
        }
        return nil
    }
}

