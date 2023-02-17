//
//  MainView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import SwiftUI

struct MainView: View {

    @ObservedObject var networkMonitor = NetworkMonitor()
    
    var body: some View {
        TabView {
            TodayView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Today")
                }
            FavoriteView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Image(systemName: "heart.text.square.fill")
                    Text("Favorite") 
                }
        }.accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
