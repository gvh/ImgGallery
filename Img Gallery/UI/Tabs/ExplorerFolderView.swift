//
//  ExplorerFolderView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct ExplorerFolderView: View {
    @ObservedObject var folder: ImageFolder

    var body: some View {
        VStack {
            List {
                ForEach(folder.subFolderValues) { subFolder in
                    ExplorerFolderRowView(subFolder: subFolder)
                }
            }
        }
        .navigationTitle(folder.noPrefixName)
    }
}
