//
//  FavoriteView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI

struct FavoriteView: View {

    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var vm = FavoriteViewModel()
    @State var shouldShowArticleDetails = false
    let viewType: ViewType = .favorites
    @State var newsViewStyle: TileSize = .small

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(0..<vm.savedArticles.count, id: \.self) { articleIndex in
                        let article = vm.savedArticles[articleIndex]
                        NewsTileView(size: newsViewStyle, article: article) {
                            RealmManager.deleteArticle(article)
                            vm.savedArticles.remove(at: articleIndex)
                        }
                        .padding(.horizontal, 1)
                        .onTapGesture {
                            shouldShowArticleDetails.toggle()
                            vm.articleForDetailsView = article
                        }
                    }
                }
            }
            .animation(.default, value: vm.savedArticles)
            .navigationTitle("Favorites")
            .onAppear { vm.updateArticleArray() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NewsStyleView(newsViewStyle: $newsViewStyle)
                        .disabled(vm.savedArticles.isEmpty)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowArticleDetails) { vm.presentWebView(from: viewType, isConnected: networkMonitor.isConnected) }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(NetworkMonitor())
    }
}
