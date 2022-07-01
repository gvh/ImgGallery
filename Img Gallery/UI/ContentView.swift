//
//  ContentView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var imageDisplay: ImageDisplay = AppData.sharedInstance.imageDisplay;
    @StateObject var settingsStore: SettingsStore = SettingsStore()

    @State var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {

            RootExplorerView()
                .tabItem {
                    Label("Explore", systemImage: "square.grid.3x3.fill")
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

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(5)
        }
        .environmentObject(imageDisplay)
        .environmentObject(settingsStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 1)
    }
}
