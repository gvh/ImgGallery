//
//  ExploreRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct ExplorerFolderRowView: View {
    @EnvironmentObject var explorerNavigator: ExplorerNavigator
    @ObservedObject var subFolder: ImageFolder

    var body: some View {
        if subFolder.files.count > 0 {
            HStack {
                NavigationLink {
                    ExplorerImageMenuView(folder: subFolder)
                } label : {
                    Label("\(subFolder.noPrefixName)", systemImage: "photo.fill.on.rectangle.fill")
                }
            }
        }
        if subFolder.subFolderValues.count > 0 {
            HStack {
                NavigationLink {
                    ExplorerFolderView(folder: subFolder)
                } label : {
                    Label("\(subFolder.noPrefixName)", systemImage: "folder.fill")
                }
            }
        }
    }
}
