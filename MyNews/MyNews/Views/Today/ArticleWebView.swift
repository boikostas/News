//
//  ArticleWebView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI

struct ArticleWebView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm: WebViewModel
    
    let pushedFromView: ViewType
    
    let article: Article
    
    init(_ pushedFrom: ViewType, article: Article) {
        self.pushedFromView = pushedFrom
        self.article = article
        self.vm = .init(urlString: article.url ?? "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                SwiftUIWebView(webViewModel: vm)
                    .ignoresSafeArea()
                    .padding(.bottom, 1)
                    .padding(.top, 1)
            }
            .navigationTitle(article.source.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { doneButton } }
            .onDisappear(perform: onDisappearAction)
        }
    }

    private var doneButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Done")
                .foregroundColor(.red)
        }
    }

    private func onDisappearAction() {
        if pushedFromView == ViewType.today || pushedFromView == ViewType.favorites {
            UITabBar.showTabBar()
        }
    }
    
        
}

struct ArticleWebView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
