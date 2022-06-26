//
//  ExploreView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var folder: ImageFolder

    var body: some View {
        VStack {
            HStack {
                Text(folder.noPrefixName)
                Spacer()
                Text("Sub: \(folder.subFolderValues.count) Fies: \(folder.files.count)")
            }
            List {
                ForEach(folder.subFolderValues) { subFolder in
                    ExploreRowView(subFolder: subFolder)
                }
            }
        }
        .navigationTitle(folder.noPrefixName)
    }
}

//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}
