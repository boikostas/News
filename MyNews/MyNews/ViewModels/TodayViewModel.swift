//
//  TodayViewModel.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI
import RealmSwift

class TodayViewModel: ObservableObject {
    
    @Published var articles = [Article]()
    @Published var categoryArticles = [Article]()
    @Published var isLoading = true
    @Published var isCategotyLoading = true
    @Published var articleForDetailsView: Article?
    @Published var errorMessage = ""
    
    init() {
        fetchTopNews(country: "")
        fetchCategoryNews("politics", country: "")
    }
    
    func fetchTopNews(country: String) {
        
        isLoading = true
        
        var urlString: String
        
        if country == "" {
            urlString = "https://newsapi.org/v2/everything?q=everything&sortBy=publishedAt&pageSize=20&language=en&apiKey=\(APIKey.key)"
        } else {
            urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&sortBy=publishedAt&pageSize=20&apiKey=\(APIKey.key)"
        }
        

            NetworkManager.shared.fetchData(from: urlString) { (data: NewsFeed?, error) in
                
                if error != nil {
                    DispatchQueue.main.async {
                        self.errorMessage = "Conection problems"
                    }
                }
                
                guard let result = data else { return }
                //TODO: Checking of favorites 
                DispatchQueue.main.async { [self] in
                    
                    articles.removeAll()
                    
                    for index in 0..<result.articles.count {
                        var article = result.articles[index]
                        article.isFavorite = false
                        article.id = UUID()
                        
                        RealmManager.correctIdForArticle(&article)
                        
                        self.articles.append(article)
                    }
                
                    RealmManager.checkIfArticleIsFavorite(in: &self.articles)
                    self.isLoading = false
                }
            }
    }
    
    func fetchCategoryNews(_ category: String, country: String) {
        
        isCategotyLoading = true
        
        var urlString: String
        
        if country == "" {
            urlString = "https://newsapi.org/v2/top-headlines?category=\(category)&sortBy=publishedAt&pageSize=10&language=en&apiKey=\(APIKey.key)"
        } else {
            urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(category)&sortBy=publishedAt&pageSize=10&apiKey=\(APIKey.key)"
        }
        
        NetworkManager.shared.fetchData(from: urlString) { (data: NewsFeed?, error) in
            
            guard let result = data else { return }
            
            DispatchQueue.main.async { [self] in
                
                categoryArticles.removeAll()
                
                for index in 0..<result.articles.count {
                    var article = result.articles[index]
                    article.isFavorite = false
                    article.id = UUID()
                    
                    RealmManager.correctIdForArticle(&article)
                    
                    self.categoryArticles.append(article)
                }
                
                RealmManager.checkIfArticleIsFavorite(in: &self.categoryArticles)
                self.isCategotyLoading = false
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
        RealmManager.checkIfArticleIsFavorite(in: &self.categoryArticles)
    }
    
}
