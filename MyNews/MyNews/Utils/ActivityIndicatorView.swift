//
//  ActivityIndicatorView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    
    let color: Color
    
    typealias UIViewType = UIActivityIndicatorView
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        aiv.color = UIColor(color)
        return aiv
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }
}
