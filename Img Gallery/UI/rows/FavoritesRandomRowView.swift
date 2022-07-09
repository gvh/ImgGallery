//
//  FavoritesRandomRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct FavoritesRandomRowView: View {
    @EnvironmentObject var favoritesNavigator: FavoritesNavigator

    var body: some View {
        VStack {
            NavigationLink{
                ImageDisplayView(file: file, isRandom: true)
            } label : {
                Image(UIImage(named: "random")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear() {
        }
    }
}
