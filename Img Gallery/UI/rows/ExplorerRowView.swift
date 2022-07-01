//
//  ExploreRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct ExplorerRowView: View {
    @ObservedObject var subFolder: ImageFolder

    var body: some View {
        if subFolder.files.count > 0 {
            HStack {
                NavigationLink {
                    ImageMenuView(folder: subFolder)
                } label : {
                    Label("\(subFolder.noPrefixName)", systemImage: "photo.fill.on.rectangle.fill")
                }
            }
        }
        if subFolder.subFolderValues.count > 0 {
            HStack {
                NavigationLink {
                    ExplorerView(folder: subFolder)
                } label : {
                    Label("\(subFolder.noPrefixName)", systemImage: "folder.fill")
                }
            }
        }
    }
}

// struct ExploreRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreRowView()
//    }
// }
