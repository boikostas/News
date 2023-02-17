//
//  CategoriesTileView.swift
//  MyNews
//
//  Created by Stas Boiko on 01.02.2023.
//

import SwiftUI

struct CategoriesTileView: View {
    
    let categories = [
        "Politics", "Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"
    ]
    
    var completion: ((String) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Categories")
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            completion?(category)
                        } label: {
                            Text(category)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .cornerRadius(10)
                        }

                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CategoriesTileView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesTileView()
    }
}
