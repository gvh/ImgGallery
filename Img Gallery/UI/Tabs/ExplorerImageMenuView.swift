//
//  ExplorerImageMenuView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/25/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ExplorerImageMenuView: View {
    @ObservedObject var folder: ImageFolder
    @EnvironmentObject var explorerNavigator: ExplorerNavigator

    let columns = [GridItem(.adaptive(minimum: 100, maximum: 250))]

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                Text(folder.noPrefixName)
                LazyVGrid(columns: columns) {
                    ForEach(folder.files, id: \.self) { file in
                        ExplorerImageCellView(file: file, fileSequence: -3, fileCount: folder.files.count)
                    }
                }
            }
            .padding()
        }
        .onAppear() {
            explorerNavigator.setCurrentFolder(currentFolder: folder)
        }
    }
}
