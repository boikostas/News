//
//  LoadingView.swift
//  MyNews
//
//  Created by Stas Boiko on 24.01.2023.
//

import SwiftUI

struct LoadingView: View {

//    @Environment(\.colorScheme) var color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 200)
            .foregroundColor(Color.loadingTile)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
