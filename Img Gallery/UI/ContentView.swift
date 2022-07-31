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
    @StateObject var folderDisplay: FolderDisplay = AppData.sharedInstance.folderDisplay;
    @StateObject var navigationDisplay: NavigationDisplay = AppData.sharedInstance.navigationDisplay

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
        .onAppear() {
            print("in contentview onappear")
            AppData.sharedInstance.fileNavigator = self.explorerNavigator
            AppData.sharedInstance.folderNavigator = nil
        }
        .onChange(of: selectedTab) { newValue in
            switch newValue {
            case 1:
                AppData.sharedInstance.fileNavigator = self.explorerNavigator
                AppData.sharedInstance.folderNavigator = nil

            case 2:
                AppData.sharedInstance.fileNavigator = self.favoritesNavigator
                AppData.sharedInstance.folderNavigator = nil

            case 3:
                AppData.sharedInstance.fileNavigator = self.historyNavigator
                AppData.sharedInstance.folderNavigator = nil

            case 4:
                AppData.sharedInstance.fileNavigator = self.searchResultsNavigator
                AppData.sharedInstance.folderNavigator = self.searchResultsNavigator

            case 5:
                AppData.sharedInstance.fileNavigator = nil

            default:
                AppData.sharedInstance.fileNavigator = nil

            }
        }
    }
}
