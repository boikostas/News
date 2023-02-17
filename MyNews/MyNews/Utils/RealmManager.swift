//
//  RealmManager.swift
//  MyNews
//
//  Created by Stas Boiko on 04.02.2023.
//

import SwiftUI
import RealmSwift

class RealmManager {
    
    static func checkIfArticleIsFavorite(in array: inout [Article]) {
        
        let realmItems = RealmManager.getAllSavedArticles()
        
        for i in 0..<array.count {
            array[i].isFavorite = false
        }
        
        if !realmItems.isEmpty {
            realmItems.forEach{ realmArticle in
            for i in 0..<array.count {
                    if realmArticle.id == array[i].id {
                        array[i].isFavorite = true
                    }
                }
            }
        }
    }
    
    static func correctIdForArticle(_ article: inout Article) {
        let realmItems = RealmManager.getAllSavedArticles()
        
        realmItems.forEach { realmArticle in
            if realmArticle.title == article.title {
                article.id = realmArticle.id
            }
        }
    }
    
    static func transformRealmToArticle(_ realmArticle: RealmArticle) -> Article {
        let article = Article(id: realmArticle.id, source: Source(id: realmArticle.sourceId, name: realmArticle.sourceName), author: realmArticle.author, title: realmArticle.title, description: realmArticle.articleDescription, url: realmArticle.url, urlToImage: realmArticle.urlToImage, content: realmArticle.content, publishedAt: realmArticle.publishedAt, isFavorite: realmArticle.isFavorite)
        return article
    }
    
    static func transfromArticleToRealmItem(_ article: Article) -> RealmArticle {
        let realmItem = RealmArticle(id: article.id ?? UUID(), sourceId: article.source.id, sourceName: article.source.name, author: article.author, title: article.title, description: article.description, url: article.url, urlToImage: article.urlToImage, publishedAt: article.publishedAt, content: article.content, isFavorite: article.isFavorite)
        return realmItem
    }
    
    static func addArticle(_ article: Article, in realm: Realm = try! Realm()) {
        let realmItem = RealmManager.transfromArticleToRealmItem(article)
        
        do {
            try realm.write {
                realm.add(realmItem)
                ImageSaverManager.shared.saveImage(from: article)
            }
        } catch {
            print("Error adding item to Realm:", error)
        }
    }
    
    static func getAllSavedArticles(in realm: Realm = try! Realm()) -> Results<RealmArticle> {
        return realm.objects(RealmArticle.self)
    }
    
    static func deleteArticle(_ article: Article, in realm: Realm = try! Realm()) {
        
            if let articleToDelete = realm.object(ofType: RealmArticle.self, forPrimaryKey: article.id) {
                do {
                    try realm.write {
                        realm.delete(articleToDelete)
                        ImageSaverManager.shared.deleteImageFromFm(article)
                    }
                } catch {
                    print("Error deleting article from Realm:", error)
                }
            }
    }
}
