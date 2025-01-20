//
//  ContentView.swift
//  WebkitSample
//
//  Created by Luis Alejandro Ramirez Suarez on 20/01/25.
//

import SwiftUI
@preconcurrency import WebKit

struct ContentView: UIViewRepresentable {
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    var url: URL
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.configuration.userContentController.add(context.coordinator, name: "callbackHandler")
        
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Updates the UIView if required
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: ContentView
        
        init(_ parent: ContentView) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            updateNavigationState(webView)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            updateNavigationState(webView)
        }
        
        private func updateNavigationState(_ webView: WKWebView) {
            DispatchQueue.main.async {
                self.parent.canGoBack = webView.canGoBack
                self.parent.canGoForward = webView.canGoForward
            }
        }
        
        // MARK: - WKScriptMessageHandler
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "callbackHandler", let messageBody = message.body as? String {
                print("JavaScript sent a message: \(messageBody)")
            }
        }
    }
}


#Preview {
    ContentView(canGoBack: .constant(true), canGoForward: .constant(true), url: URL(string: "https://www.google.com")!)
}
