//
//  Article.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI

struct Article: Decodable, Identifiable, Equatable {
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.url == rhs.url
    }
    
    var id: UUID? = UUID()
    let source: Source
    let author, title, description, url, urlToImage, content: String?
    let publishedAt: String?
    var isFavorite: Bool? = false
    
}

