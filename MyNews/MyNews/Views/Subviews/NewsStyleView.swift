//
//  NewsStyleView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.02.2023.
//

import SwiftUI

struct NewsStyleView: View {

    @Binding var newsViewStyle: TileSize

    var body: some View {
            Menu {
                newsStyleViewButton(.small)
                newsStyleViewButton(.large)
            } label: {
                newsViewStyle.icon
            }
    }

    @ViewBuilder
    private func newsStyleViewButton(_ style: TileSize) -> some View {
        Button {
            newsViewStyle = style
        } label: {
            HStack {
                Text(style.title)
                style.icon
            }
        }

    }
}

//struct NewsStyleView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsStyleView()
//    }
//}
