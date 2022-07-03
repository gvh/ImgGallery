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

    var explorerNavigator = ExplorerNavigator()
    var favoritesNavigator = FavoritesNavigator()
    var historyNavigator = HistoryNavigator()
    var searchNavigator = SearchNavigator()

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
        .onChange(of: selectedTab) { newValue in
            switch newValue {
            case 1:
                AppData.sharedInstance.imageDisplay.navigator = self.explorerNavigator

            case 2:
                AppData.sharedInstance.imageDisplay.navigator = self.favoritesNavigator

            case 3:
                AppData.sharedInstance.imageDisplay.navigator = self.historyNavigator

            case 4:
                AppData.sharedInstance.imageDisplay.navigator = self.searchNavigator

            case 5:
                AppData.sharedInstance.imageDisplay.navigator = nil

            default:
                AppData.sharedInstance.imageDisplay.navigator = nil

            }
        }
    }
}
