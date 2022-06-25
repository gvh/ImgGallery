//
//  ExploreView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct ExploreView: View {
    @State var rootFolder: ImageFolder?

    init() {
        rootFolder = AppData.sharedInstance.downloadTOC?.rootFolder
    }

    var body: some View {
        VStack {
            List {
                if rootFolder != nil {
                    ForEach(rootFolder!.subFolderValues) { folder in
                        ExploreRowView(folder: folder)
                    }
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
