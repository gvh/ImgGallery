//
//  ExploreRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct ExploreRowView: View {
    @ObservedObject var subFolder: ImageFolder

    var body: some View {
        if subFolder.files.count > 0 {
            HStack {
                NavigationLink {
                    ImageMenuView(folder: subFolder)
                } label : {
                    Label("images: \(subFolder.noPrefixName)", systemImage: "photo.fill.on.rectangle.fill")
                }
            }
        } else {
            HStack {
                NavigationLink {
                    ExploreView(folder: subFolder)
                } label : {
                    Label("folders: \(subFolder.noPrefixName)", systemImage: "folder.fill")
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
