//
//  SearchView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @EnvironmentObject var searchResultsNavigator: SearchResultsNavigator

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { searchResult in
                    NavigationLink(destination: SearchImageMenuView(folderDisplay: searchResult.folderDisplay)  ) {
                        Text(searchResult.folderDisplay.name)
                        Spacer()
                        Text(String(searchResult.hitCount))
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Image Search")
        }
        .navigationViewStyle(.stack)
        .onAppear() {
            AppData.sharedInstance.imageDisplay.setNavigator(navigator: searchResultsNavigator)
        }
    }

    var searchResults: [SearchResult] {
        if searchText.isEmpty {
            return []
        } else {
            let searchFolders = AppData.sharedInstance.downloadAllFolders.filter { $0.noPrefixName.localizedLowercase.contains(searchText) }
            let results = searchFolders.map { SearchResult(folder: $0, hitCount: $0.files.count) }
            searchResultsNavigator.setResults(results: results)
            return results
        }
    }
}
