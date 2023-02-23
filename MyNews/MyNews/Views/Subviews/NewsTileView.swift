//
//  NewsTileView.swift
//  MyNews
//
//  Created by Stas Boiko on 25.01.2023.
//

import SwiftUI
import SDWebImageSwiftUI

enum TileSize {
    case small, large

    var title: String {
        switch self {
        case .small:
            return "List"
        case .large:
            return "Blocks"
        }
    }

    var icon: Image {
        switch self {
        case .small:
            return Image(systemName: "list.clipboard.fill")
        case .large:
            return Image(systemName: "square.text.square.fill")
        }
    }
}

struct NewsTileView: View {
    
    let size: TileSize
    let article: Article
    
    let heartButtonAction: (() -> Void)?

    var body: some View {

        switch size {
        case .small:
            buildSmallNewsTile()
        case .large:
            buildLargeNewsTile()
        }
    }

    @ViewBuilder
    private func buildLargeNewsTile() -> some View {
        VStack(alignment: .leading) {

            VStack {
                if article.urlToImage != nil  {
                    WebImage(url: URL(string: article.urlToImage ?? ""))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 180)
                        .clipped()
                }

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.source.name ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                        Text(article.title ?? "")
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .padding(article.urlToImage == "" || article.urlToImage == nil ? [.horizontal, .top] : .horizontal)
                    Spacer()
                }
            }

            Divider()
                .background(Color.divider)

            HStack {
                Group {
                    Image(systemName: "clock")
                    Text((article.publishedAt ?? "").formatData())
                        .lineLimit(1)
                    if article.author != nil {
                        Text("•   \(article.author ?? "")")
                            .lineLimit(1)
                    }
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)

                Spacer()

                Button {
                    heartButtonAction?()
                } label: {
                    Image(systemName: (article.isFavorite ?? false) ? "heart.fill" : "heart")
                        .foregroundColor((article.isFavorite ?? false) ? .red : Color(.label))
                }
                .foregroundColor(Color(.label))
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

        }
        .frame(maxWidth: 350)
        .background(Color.tileBackground)
        .cornerRadius(10)
        .padding(.top)
        .shadow(radius: 2, x: 1, y: 1)

    }

    @ViewBuilder
    private func buildSmallNewsTile() -> some View {
        HStack(spacing: 15) {
            if article.urlToImage != nil || article.urlToImage == "" {
                WebImage(url: URL(string: article.urlToImage ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(15)
            } else {
                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(article.title ?? "")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()

                    Button {
                        heartButtonAction?()
                    } label: {
                        Image(systemName: (article.isFavorite ?? false) ? "heart.fill" : "heart")
                            .foregroundColor((article.isFavorite ?? false) ? .red : Color(.label))
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color(.label))
                }

                HStack {
                    Image(systemName: "clock")
                    Text((article.publishedAt ?? "").formatData())
                        .lineLimit(1)
                    Text("•")
                    Text(article.source.name ?? "")
                        .padding(.trailing)
                        .lineLimit(1)
                        .foregroundColor(.red)

                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
            }
        }
        .frame(height: 70)
        .background(Color.tileBackground)
        .cornerRadius(15)
        .padding(.horizontal)
        .shadow(radius: 4, x: 1, y: 1)
    }
}
