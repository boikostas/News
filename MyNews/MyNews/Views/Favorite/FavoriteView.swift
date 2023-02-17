//
//  FavoriteView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
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
                //TODO: No connection view
                VStack {
                    NoConnectionNewsView(article: article)
                }
            }
        }
    }
}


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
                    Menu("View style") {
                        Button("Small") {
                            newsViewStyle = .small
                        }
                        Button("Large") {
                            newsViewStyle = .large
                        }
                    }
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
