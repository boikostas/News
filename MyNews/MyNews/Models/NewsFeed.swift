//
//  NewsFeed.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import Foundation

struct NewsFeed: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
