//
//  AllCategoryNewsView.swift
//  MyNews
//
//  Created by Stas Boiko on 02.02.2023.
//

import SwiftUI

struct AllCategoryNewsView: View {
    
    let category: String
    let country: Country
    let viewType = ViewType.categoryNews
    
    @ObservedObject var vm: AllCategoryNewsViewModel
    
    @State var shouldShowArticleDetails = false
    @State var newsViewStyle: TileSize = .small
    
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
                            NewsTileView(size: newsViewStyle, article: article) {
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NewsStyleView(newsViewStyle: $newsViewStyle)
            }
        }
        
    }
}

struct AllCategoryNewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllCategoryNewsView(category: "Politics", country: Country.ukraine)
        }
    }
}
