//
//  AllWorldNewsViewModel.swift
//  MyNews
//
//  Created by Stas Boiko on 23.02.2023.
//

import SwiftUI

class AllWorldNewsViewModel: ObservableObject {

    @Published var isLoading = true
    @Published var articles = [Article]()
    @Published var articleForDetailsView: Article?

    init(country: String) {
        fetchData(country: country)
    }

    func fetchData(country: String) {

        var urlString: String

        if country == "" {
            urlString = "https://newsapi.org/v2/everything?q=everything&sortBy=publishedAt&language=en&apiKey=\(APIKey.key)"
        } else {
            urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&sortBy=publishedAt&apiKey=\(APIKey.key)"
        }


        NetworkManager.shared.fetchData(from: urlString) { (data: NewsFeed?, error) in
            guard let result = data?.articles else { return }

            DispatchQueue.main.async {

                for i in 0..<result.count {
                    var article = result[i]
                    article.id = UUID()

                    RealmManager.correctIdForArticle(&article)

                    self.articles.append(article)
                }

                RealmManager.checkIfArticleIsFavorite(in: &self.articles)
                self.isLoading = false
            }
        }
    }

    func onTapLikeButtonAction(articleIndex: Int, in array: inout [Article]) {
        if array[articleIndex].isFavorite ?? false {
            array[articleIndex].isFavorite?.toggle()
            RealmManager.deleteArticle(array[articleIndex])
        } else {
            array[articleIndex].isFavorite?.toggle()
            RealmManager.addArticle(array[articleIndex])
        }
    }

    @ViewBuilder
    func presentWebView(from viewType: ViewType) -> some View {
        if let article = self.articleForDetailsView {
            ArticleWebView(viewType, article: article)
        }
    }

    func onAppearAction() {
        RealmManager.checkIfArticleIsFavorite(in: &self.articles)
        UITabBar.hideTabBar()
    }

    func onDisapperaAction() {
        UITabBar.showTabBar()
    }
}
