//
//  ImageSaverManager.swift
//  MyNews
//
//  Created by Stas Boiko on 17.02.2023.
//

import SwiftUI

class ImageSaverManager {

    static let shared = ImageSaverManager()
    private init() {}

    func saveImage(from article: Article) {
        guard
            let imageUrl = URL(string: article.urlToImage ?? ""),
            let url = getDocumentsDirectory()?.appendingPathComponent(article.id?.uuidString ?? "")
        else { return }

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: imageUrl)
                try data.write(to: url)
                print(url.path)
            } catch let error {
                print("Error saving image:", error)
            }
        }
    }

    private func getDocumentsDirectory() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return url
    }

    func getImageFromFM(for article: Article) -> Image? {
        guard let url = getDocumentsDirectory()?.appendingPathComponent(article.id?.uuidString ?? ""),
              let uiImage = UIImage(contentsOfFile: url.path)
        else { return nil }
        let image = Image(uiImage: uiImage)
        return image
    }

    func deleteImageFromFm(_ article: Article) {
        guard let url = getDocumentsDirectory()?.appendingPathComponent(article.id?.uuidString ?? "") else { return }

        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            } catch let error {
                print("Error deleting image file from FM:", error)
            }
        }
    }
}
