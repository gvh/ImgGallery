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
                ImageDisplayView(file: favoritesNavigator.getRandomFile()!)
            } label : {
                Image(uiImage: UIImage(named: "Random")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
