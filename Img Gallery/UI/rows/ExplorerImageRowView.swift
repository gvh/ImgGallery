//
//  ExplorerImageRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ExplorerImageRowView: View {
    @EnvironmentObject var explorerNavigator: ExplorerNavigator
    @ObservedObject var file: ImageFile
    @State var fileSequence: Int
    @State var fileCount: Int

    var body: some View {
        VStack {
            NavigationLink{
                ImageDisplayView(file: file)
            } label : {
                Image(uiImage: file.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear() {
            explorerNavigator.setCurrentFile(file: file)
            file.getDisplayImage(fileSequence: fileSequence, fileCount: fileCount)
        }
    }
}
