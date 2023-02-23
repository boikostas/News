//
//  FavoriteViewModel.swift
//  MyNews
//
//  Created by Stas Boiko on 23.02.2023.
//

import SwiftUI
import RealmSwift

class FavoriteViewModel: ObservableObject {

    @Published var savedArticles = [Article]()
    @Published var articleForDetailsView: Article?
    var items: Results<RealmArticle>?

    func updateArticleArray() {
        savedArticles.removeAll()
        items = RealmManager.getAllSavedArticles()
        items?.forEach { realmArticle in
            let article = RealmManager.transformRealmToArticle(realmArticle)
            savedArticles.append(article)
        }
    }

    @ViewBuilder
    func presentWebView(from viewType: ViewType, isConnected: Bool) -> some View {
        if let article = self.articleForDetailsView {
            if isConnected {
                ArticleWebView(viewType, article: article)
            } else {
                VStack {
                    NoConnectionNewsView(article: article)
                }
            }
        }
    }
}
