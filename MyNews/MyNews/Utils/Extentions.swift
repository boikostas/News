//
//  Extentions.swift
//  MyNews
//
//  Created by Stas Boiko on 11.02.2023.
//

import Foundation

extension String {
    func formatData() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let datePublished = formatter.date(from: self)!

        formatter.dateFormat = "dd.MM.yy"

        let formattedPublishedDate = formatter.string(from: datePublished)

        let currentDate = Date()

        let currentFormattedDate = formatter.string(from: currentDate)

        if formattedPublishedDate != currentFormattedDate {
            formatter.dateFormat = "d MMM, HH:mm"
            return formatter.string(from: datePublished)
        } else {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: datePublished)
        }
    }
}
