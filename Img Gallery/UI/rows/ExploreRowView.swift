//
//  ExploreRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct ExploreRowView: View {
    @State var folder: ImageFolder

    var body: some View {
        HStack {
            Text(folder.noPrefixName)
            Spacer()
            Image(uiImage: folder.getImage())
        }
    }
}

// struct ExploreRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreRowView()
//    }
// }
