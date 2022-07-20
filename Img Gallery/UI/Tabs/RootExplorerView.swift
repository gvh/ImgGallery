//
//  RootExplorerView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct RootExplorerView: View {
    @EnvironmentObject var explorerNavigator: ExplorerNavigator

    var body: some View {

        NavigationView {
            ExplorerFolderView(folder: (AppData.sharedInstance.downloadTOC?.rootFolder)!)
        }
        .navigationViewStyle(.stack)
        .onAppear() {
            explorerNavigator.setCurrentFolder(currentFolder: AppData.sharedInstance.downloadTOC.rootFolder)
        }
    }
}
