//
//  LoadingView.swift
//  MyNews
//
//  Created by Stas Boiko on 24.01.2023.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color.init(white: 0.95))
            .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 200)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
