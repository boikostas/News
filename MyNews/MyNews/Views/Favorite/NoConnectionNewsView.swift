//
//  NoConnectionNewsView.swift
//  MyNews
//
//  Created by Stas Boiko on 17.02.2023.
//

import SwiftUI

class NoConnectionNewsViewModel: ObservableObject {

    var article: Article

    init(article: Article) {
        self.article = article
    }

    func getImage() -> Image? {
        guard let url = URL(string: article.urlToImage ?? ""),
              let data = try? Data(contentsOf: url),
              let uiImage = UIImage(data: data)
        else { return nil }

        let image = Image(uiImage: uiImage)
        return image
    }
}

struct NoConnectionNewsView: View {

    @Environment(\.presentationMode) var presentationMode

    let article: Article
    @ObservedObject var vm: NoConnectionNewsViewModel

    init(article: Article) {
        self.article = article
        self.vm = .init(article: article)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                image
                VStack(alignment: .leading, spacing: 20) {
                    titleLabel
                    HStack {
                        authorLabel
                        dateLabel
                    }
                    content
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle(article.source.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { doneButton }
        }
        }

    }

    private var image: some View {
        ImageSaverManager.shared.getImageFromFM(for: article)?
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    private var titleLabel: some View {
        Text(article.title ?? "")
            .multilineTextAlignment(.center)
            .font(.system(size: 20, weight: .bold))
    }

    @ViewBuilder
    private var authorLabel: some View {
        if article.author != nil {
            Text(article.author ?? "")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.red)
        }
    }

    private var dateLabel: some View {
        Group {
            Image(systemName: "clock")
            Text((article.publishedAt ?? "").formatData())
        }
        .foregroundColor(.gray)
        .font(.system(size: 16, weight: .semibold))
    }

    private var content: some View {
        Text(article.content ?? "")
            .font(.system(size: 18, weight: .regular))
    }

    private var doneButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Done")
                .foregroundColor(.red)
        }
    }
}

struct NoConnectionNewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoConnectionNewsView(article:
    Article(id: UUID(), source: Source(id: nil, name: "Lifehacker.com"), author: "Brendan Hesse", title: "Every Game Coming to PlayStation Plus and Xbox Game Pass in February 2023", description: "PlayStation and Xbox fans will have plenty to play this month through their PlayStation Plus or Xbox Game Pass subscriptions. Both companies have announced February’s new monthly downloadable games and new additions to their respective services, as well as a …", url: "https://lifehacker.com/every-game-coming-to-playstation-plus-and-xbox-game-pas-1850062646", urlToImage: "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/3c8aacdba5ab4be8cc592ec0c945b1c9.png", content: "PlayStation and Xbox fans will have plenty to play this month through their PlayStation Plus or Xbox Game Pass subscriptions. Both companies have announced Februarys new monthly downloadable games an… [+5478 chars]", publishedAt: "2023-02-02T16:30:00Z", isFavorite: true)
            )
        }
    }
}
