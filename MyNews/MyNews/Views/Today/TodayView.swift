//
//  TodayView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI
import HidableTabView

struct TodayView: View {

    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var vm = TodayViewModel()
    @State var shouldShowArticleDetails = false
    @State var shouldShowSearchView = false
    @State var catergory = "politics"
    @State var selectedCountry = Country.none
    let viewType = ViewType.today
    
    var body: some View {
        
        NavigationView {
            VStack {
                switch networkMonitor.isConnected {
                case false:
                    NoInternetConnectionView()
                case true:
                    buildIsConnectedView()
                }
            }
            .navigationTitle("Today")
            .fullScreenCover(isPresented: $shouldShowSearchView) { SearchView() }
            .fullScreenCover(isPresented: $shouldShowArticleDetails) { vm.presentWebView(from: viewType) }
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { searchButton } }
        }
        .onAppear { vm.onAppearAction() }
    }

    @ViewBuilder
    private func buildIsConnectedView() -> some View {
        ScrollView {

            VStack {

                Divider()
                    .background(Color.divider)
                    .padding(.top)

                countryPickerView

                Divider()
                    .background(Color.divider)

                topNewsView

                categoryNewsView

            }
        }
    }
}

extension TodayView {
    
    private var countryPickerView: some View {
        HStack {
            Text("Choose country:")
                .foregroundColor(.gray)
                .font(.system(size: 20, weight: .bold))
            
            Picker("\(selectedCountry.rawValue.capitalized)", selection: $selectedCountry) {
                ForEach(Country.allCases, id: \.self) { country in
                    Text(country.rawValue.capitalized)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedCountry) { newValue in
                vm.fetchTopNews(country: newValue.countryId)
                vm.fetchCategoryNews(catergory, country: newValue.countryId)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var topNewsView: some View {
        
        VStack {
            
            HStack {
                Text("\(selectedCountry.rawValue.capitalized) news")
                    .font(.system(size: 25, weight: .bold))
                Spacer()
                NavigationLink {
                    NavigationLazyView(AllWorldNewsView(country: selectedCountry))
                } label: {
                    Text("See all")
                        .foregroundColor(Color.red)
                }
                
            }
            .padding(.horizontal)

            if vm.isLoading {
                LoadingView()
                    .padding(.horizontal)
                    .frame(height: 250)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 15) {
                        ForEach(0..<vm.articles.count, id: \.self) { articleIndex in

                            let article = vm.articles[articleIndex]
                            NewsTileView(size: .large, article: article) {
                                vm.onTapLikeButtonAction(articleIndex: articleIndex, in: &vm.articles)
                            }
                            .onTapGesture {
                                shouldShowArticleDetails.toggle()
                                vm.articleForDetailsView = article
                            }
                            .frame(width: 350)
                            .padding(.bottom)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private var categoryNewsView: some View {
        
        VStack {
            CategoriesTileView() { category in
                vm.fetchCategoryNews(category.lowercased(), country: selectedCountry.countryId)
                self.catergory = category
            }
            
            if vm.isCategotyLoading {
                ForEach(0..<5) { view in
                    LoadingView()
                        .padding([.horizontal])
                }
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(0..<vm.categoryArticles.count, id: \.self) { articleIndex in
                            let article = vm.categoryArticles[articleIndex]
                            NewsTileView(size: .small, article: article) {
                                vm.onTapLikeButtonAction(articleIndex: articleIndex, in: &vm.categoryArticles)
                            }
                            .onTapGesture {
                                shouldShowArticleDetails.toggle()
                                vm.articleForDetailsView = article
                            }
                        }
                    }
                    .padding([.bottom, .top])
                }
                HStack {
                    Spacer()
                    NavigationLink {
                        NavigationLazyView(AllCategoryNewsView(category: catergory, country: selectedCountry))
                    } label: {
                        Text("See all")
                            .foregroundColor(Color.red)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var searchButton: some View {
        Button {
            shouldShowSearchView.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
                .foregroundColor(networkMonitor.isConnected ? .red : .gray)
                .font(.system(size: 20))
        }
        .disabled(!networkMonitor.isConnected)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(NetworkMonitor())
    }
}
