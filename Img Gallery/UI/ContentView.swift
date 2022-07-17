//
//  ContentView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject var imageDisplay: ImageDisplay = AppData.sharedInstance.imageDisplay;
    @StateObject var settingsStore: SettingsStore = SettingsStore()
    @StateObject var explorerNavigator = ExplorerNavigator(currentFolder: AppData.sharedInstance.downloadTOC.rootFolder, currentPosition: 0)
    @StateObject var favoritesNavigator = FavoritesNavigator()
    @StateObject var historyNavigator = HistoryNavigator()
    @StateObject var searchResultsNavigator = SearchResultsNavigator( searchResults: [])

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
        .environmentObject(explorerNavigator)
        .environmentObject(favoritesNavigator)
        .environmentObject(historyNavigator)
        .environmentObject(searchResultsNavigator)

        .onChange(of: selectedTab) { newValue in
            switch newValue {
            case 1:
                AppData.sharedInstance.navigator = self.explorerNavigator

            case 2:
                AppData.sharedInstance.navigator = self.favoritesNavigator

            case 3:
                AppData.sharedInstance.navigator = self.historyNavigator

            case 4:
                AppData.sharedInstance.navigator = self.searchResultsNavigator

            case 5:
                AppData.sharedInstance.navigator = nil

            default:
                AppData.sharedInstance.navigator = nil

            }
        }
    }
}
