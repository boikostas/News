//
//  AllCategoryNewsView.swift
//  MyNews
//
//  Created by Stas Boiko on 02.02.2023.
//

import SwiftUI

class AllCategoryNewsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var articles = [Article]()
    @Published var articleForDetailsView: Article?
    
    init(category: String, country: String) {
        fetchCategoryNews(category.lowercased(), country: country)
    }
    
    func fetchCategoryNews(_ category: String, country: String) {
        
        var urlString: String
        
        if country == "" {
            urlString = "https://newsapi.org/v2/top-headlines?category=\(category)&sortBy=publishedAt&language=en&apiKey=\(APIKey.key)"
        } else {
            urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(category)&sortBy=publishedAt&apiKey=\(APIKey.key)"
        }
        
        NetworkManager.shared.fetchData(from: urlString) { (data: NewsFeed?, error) in
            
            guard let result = data?.articles else { return }
            
            DispatchQueue.main.async { [self] in
                
                for i in 0..<result.count {
                    var article = result[i]
                    article.id = UUID()
                    
                    RealmManager.correctIdForArticle(&article)
                    
                    self.articles.append(article)
                }
                
                RealmManager.checkIfArticleIsFavorite(in: &articles)
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

struct AllCategoryNewsView: View {
    
    let category: String
    let country: Country
    let viewType = ViewType.categoryNews
    
    @ObservedObject var vm: AllCategoryNewsViewModel
    
    @State var shouldShowArticleDetails = false
    
    init(category: String, country: Country) {
        self.category = category
        self.country = country
        self.vm = .init(category: category, country: country.countryId)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                if vm.isLoading {
                    ForEach(0..<10) { _ in
                        LoadingView()
                            .padding(.horizontal)
                    }
                } else {
                    VStack(spacing: 15) {
                        ForEach(0..<vm.articles.count, id: \.self) { articleIndex in
                            let article = vm.articles[articleIndex]
                            NewsTileView(size: .small, article: article) {
                                vm.onTapLikeButtonAction(articleIndex: articleIndex, in: &vm.articles)
                            }
                            .onTapGesture {
                                shouldShowArticleDetails.toggle()
                                vm.articleForDetailsView = article
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("\(country.rawValue.capitalized) \(category.lowercased()) news")
        .fullScreenCover(isPresented: $shouldShowArticleDetails) { vm.presentWebView(from: viewType) }
        .onAppear { vm.onAppearAction() }
        .onDisappear { vm.onDisapperaAction() } 
        
    }
}

struct AllCategoryNewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllCategoryNewsView(category: "Politics", country: Country.ukraine)
        }
    }
}
