//
//  NewsTileView.swift
//  MyNews
//
//  Created by Stas Boiko on 25.01.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import RealmSwift

enum TileSize {
    case small, large
}

struct NewsTileView: View {
    
    let size: TileSize
    let article: Article
    
    let heartButtonAction: (() -> Void)?
    
    var body: some View {
        
        if size == .large {
            
            //MARK: Large news tile
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
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top)
            .shadow(radius: 2, x: 1, y: 1)
            
        } else {
            
            //MARK: Small news tile
            HStack(spacing: 15) {
                if article.urlToImage != nil {
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
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal)
            .shadow(radius: 4, x: 1, y: 1)
        }
    }
}

//struct NewsTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsTileView()
//    }
//}
