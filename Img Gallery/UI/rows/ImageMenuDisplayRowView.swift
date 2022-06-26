//
//  ImageDisplayRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/25/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ImageMenuDisplayRowView: View {
    @ObservedObject var subFolder: ImageFolder

    var body: some View {
        HStack {
            NavigationLink {
                ImageMenuView(folder: subFolder)
            } label : {
                Label(subFolder.noPrefixName, systemImage: "folder.fill")
            }
        }
    }
}

//struct ImageDisplayRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageMenuDisplayRowView()
//    }
//}
