//
//  WebView.swift
//  MyNews
//
//  Created by Stas Boiko on 24.01.2023.
//

import SwiftUI
import WebKit

struct SwiftUIWebView: UIViewRepresentable {
    
    @ObservedObject var webViewModel: WebViewModel
    
    let webView = WKWebView()
    
    func makeCoordinator() -> SwiftUIWebView.Coordinator {
        Coordinator(self.webViewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        self.webView.navigationDelegate = context.coordinator
        self.webView.allowsBackForwardNavigationGestures = true
        
        if let url = URL(string: self.webViewModel.urlString) {
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url))
            }
        }
        
        return self.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    typealias UIViewType = WKWebView
}


extension SwiftUIWebView {
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var webViewModel: WebViewModel
        
        init(_ webViewModel: WebViewModel) {
            self.webViewModel = webViewModel
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webViewModel.isLoading = false
        }
    }
    
}
