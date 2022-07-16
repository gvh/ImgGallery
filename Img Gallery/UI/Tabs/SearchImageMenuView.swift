//
//  SearchImageMenuView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/25/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct SearchImageMenuView: View {
    @ObservedObject var folderDisplay: FolderDisplay
    @EnvironmentObject var searchNavigator: SearchResultsNavigator

    let columns = [GridItem(.adaptive(minimum: 100, maximum: 250))]

    var body: some View {
        VStack {
            ScrollView(.vertical) {

                Text(folderDisplay.name)

                if AppData.sharedInstance.imageDisplay.hasResultButtons {
                    HStack {
                        Button("<< Prev Result") {
                            AppData.sharedInstance.imageDisplay.navigator?.doPrevResult()
                        }
                        Spacer()
                        Button("Next Result >>") {
                            AppData.sharedInstance.imageDisplay.navigator?.doNextResult()
                        }
                    }
                }

                LazyVGrid(columns: columns) {
                    ForEach(folderDisplay.files, id: \.self) { file in
                        SearchImageRowView(file: file)
                    }
                }
            }
            .padding()
        }
        .onAppear() {
            AppData.sharedInstance.imageDisplay.setNavigator(navigator: searchNavigator)
            searchNavigator.setFolderDisplay(folderDisplay: folderDisplay)

//            searchNavigator.setCurrentFolder(currentFolder: folder)
        }
    }
}
