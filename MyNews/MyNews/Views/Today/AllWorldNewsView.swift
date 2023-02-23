//
//  AllWorldNewsView.swift
//  MyNews
//
//  Created by Stas Boiko on 01.02.2023.
//

import SwiftUI

struct AllWorldNewsView: View {
    
    let country: Country
    let viewType = ViewType.topNews
    
    @ObservedObject var vm: AllWorldNewsViewModel
    @State var shouldShowArticleDetails = false
    @State var newsViewStyle: TileSize = .small
    
    init(country: Country) {
        self.country = country
        self.vm = .init(country: country.countryId)
    }
    
    var body: some View {
        
        VStack {
            ScrollView {
                if vm.isLoading {
                    ForEach(0..<10) { view in
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
        .navigationTitle("\(country.rawValue.capitalized) news")
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

struct AllWorldNewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllWorldNewsView(country: Country.none)
        }
    }
}
