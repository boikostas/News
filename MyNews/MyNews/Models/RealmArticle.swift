//
//  RealmArticle.swift
//  MyNews
//
//  Created by Stas Boiko on 09.02.2023.
//

import Foundation
import RealmSwift

class RealmArticle: Object, Identifiable {
    @Persisted var id = UUID()
    @Persisted var sourceId: String? = nil
    @Persisted var sourceName: String? = nil
    @Persisted var author: String? = nil
    @Persisted var title: String? = nil
    @Persisted var articleDescription: String? = nil
    @Persisted var url: String? = nil
    @Persisted var urlToImage: String? = nil
    @Persisted var publishedAt: String? = nil
    @Persisted var content: String? = nil
    @Persisted var isFavorite: Bool? = nil
    
    override static func primaryKey() -> String? {
           return "id"
       }
    
    convenience init(id: UUID,
                     sourceId: String?,
                     sourceName: String?,
                     author: String?,
                     title: String?,
                     description: String?,
                     url: String?,
                     urlToImage: String?,
                     publishedAt: String?,
                     content: String?,
                     isFavorite: Bool?)
    {
        self.init()
        self.id = id
        self.sourceId = sourceId
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.articleDescription = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.isFavorite = isFavorite
    }
}
