//
//  NoInternetConnectionView.swift
//  MyNews
//
//  Created by Stas Boiko on 23.02.2023.
//

import SwiftUI

struct NoInternetConnectionView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 40, weight: .semibold))
            Text("Check your internet connection!")
                .font(.system(size: 20, weight: .semibold))
        }
    }
}

struct NoInternetConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetConnectionView()
    }
}
