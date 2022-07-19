//
//  SearchImageMenuView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/25/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct SearchImageMenuView: View {
    @ObservedObject var folder: ImageFolder
    @EnvironmentObject var searchNavigator: SearchResultsNavigator
    @EnvironmentObject var imageDisplayh: ImageDisplay

    let columns = [GridItem(.adaptive(minimum: 100, maximum: 250))]

    var body: some View {
        VStack {
            ScrollView(.vertical) {

                Text(folder.noPrefixName)

                if AppData.sharedInstance.navigationDisplay.hasResultButtons {
                    HStack {
                        Button("<< Prev Result") {
                            AppData.sharedInstance.folderNavigator?.doPrevResult()
                        }
                        Spacer()
                        Button("Next Result >>") {
                            AppData.sharedInstance.folderNavigator?.doNextResult()
                        }
                    }
                }

                LazyVGrid(columns: columns) {
                    ForEach(folder.files, id: \.self) { file in
                        SearchImageRowView(file: file)
                    }
                }
            }
            .padding()
        }
        .onAppear() {
            searchNavigator.setCurrentFolder(currentFolder: folder)
        }
    }
}
