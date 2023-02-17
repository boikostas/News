//
//  WebViewModel.swift
//  MyNews
//
//  Created by Stas Boiko on 24.01.2023.
//

import Foundation

class WebViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
}
