//
//  SearchView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI
import Introspect

class SearchViewModel: ObservableObject {
    
    @Published var articles = [Article]()
    @Published var isLoading = false
    @Published var searchText: String?
    @Published var articleForDetailsView: Article?
    
    func fetchSearchedArticles() {
        
        let urlString = "https://newsapi.org/v2/everything?q=\(searchText ?? "")&sortBy=relevancy&sortBy=popularity&apiKey=275ad869b67c46078cf49749471471cc"
        
        isLoading = true
        
        NetworkManager.shared.fetchData(from: urlString) { (data: NewsFeed?, error) in
            
            guard let result = data?.articles else { return }
            
            self.articles.removeAll()
            
            DispatchQueue.main.async { [self] in
                
                for i in 0..<result.count {
                    var article = result[i]
                    article.id = UUID()
                    
                    RealmManager.correctIdForArticle(&article)
                    articles.append(article)
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
    
}

struct SearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let viewType = ViewType.search
    
    @State private var searchText = ""
    @State var shouldShowArticleDetails = false
    
    @ObservedObject var vm = SearchViewModel()
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                searchBar
                
                if vm.isLoading {
                    ActivityIndicatorView(color: .gray)
                } else {
                    ScrollView(showsIndicators: false) {
                        
                        ForEach(0..<vm.articles.count, id: \.self) { articleIndex in
                            let article = vm.articles[articleIndex]
                            
                            NewsTileView(size: .small, article: article) {
                                vm.onTapLikeButtonAction(articleIndex: articleIndex, in: &vm.articles)
                            }
                            .onTapGesture {
                                shouldShowArticleDetails.toggle()
                                vm.articleForDetailsView = article
                            }
                            .padding(.bottom, 5)
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $shouldShowArticleDetails, content: {
                if let article = vm.articleForDetailsView {
                    ArticleWebView(self.viewType, article: article)
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { closeButton }
            }
        }
    }
    
    private var closeButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Close")
                .foregroundColor(.red)
        }
    }
    
    private var searchBar: some View {
        SearchBar(text: $searchText, viewModel: vm, commit: {
                               self.vm.searchText = searchText
                               self.vm.fetchSearchedArticles()
                           })
        .padding(.top)
        .padding(.bottom)
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
