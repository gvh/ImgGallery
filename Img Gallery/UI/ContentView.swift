//
//  ContentView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RootExplorerView()
            .tabItem {
                Image(systemName: "square.grid.3x3.fill")
                Text("Explore")
            }
            .tag(1)
            FavoritesView()
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            .tag(2)
            HistoryView()
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
            .tag(3)
            SearchView()
            .tabItem {
                Image(systemName: "magnifyingglass.circle.fill")
                Text("Search")
            }
            .tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
