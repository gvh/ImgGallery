//
//  FavoritesView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct FavoritesView: View {

    @ObservedObject var favorites: Favorites = AppData.sharedInstance.favorites

    let columns = [GridItem(.adaptive(minimum: 100, maximum: 300))]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    Text("Favorites")
                    LazyVGrid(columns: columns) {
                        ForEach(favorites.items, id: \.self) { favorite in
                            FavoritesImageRowView(file: favorite.file)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}
