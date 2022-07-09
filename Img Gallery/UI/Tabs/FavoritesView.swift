//
//  FavoritesView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct FavoritesView: View {

    @ObservedObject var favorites: Favorites = AppData.sharedInstance.favorites
    @EnvironmentObject var favoritesNavigator: FavoritesNavigator

    let columns = [GridItem(.adaptive(minimum: 100, maximum: 300))]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    Text("Favorites")
                    LazyVGrid(columns: columns) {
                        FavoritesRandomRowView()
                        ForEach(favorites.items, id: \.self) { favorite in
                            FavoritesImageRowView(file: favorite.file)
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                if AppData.sharedInstance.isTimerActive {
                    Button("Pause") {
                        AppData.sharedInstance.imageDisplay.navigator?.togglePlayPause()
                    }
                } else {
                    Button("Play") {
                        AppData.sharedInstance.imageDisplay.navigator?.togglePlayPause()
                        let position = favoritesNavigator.getRandomPosition()
                        let file = AppData.sharedInstance.favorites.items[position]
                        ImageDisplayView(file: file)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear() {
            AppData.sharedInstance.imageDisplay.setNavigator(navigator: favoritesNavigator)
        }
    }
}
