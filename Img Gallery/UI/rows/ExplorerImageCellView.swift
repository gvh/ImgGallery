//
//  ExplorerImageCellView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ExplorerImageCellView: View {
    @EnvironmentObject var explorerNavigator: ExplorerNavigator
    @State var file: ImageFile
    @State var imageDisplay = ImageDisplay()
    @State var fileSequence: Int
    @State var fileCount: Int

    var body: some View {
        VStack {
            NavigationLink{
                ImageDisplayView(file: file)
            } label : {
                Image(uiImage: imageDisplay.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear() {
            explorerNavigator.setCurrentFile(file: file)
            imageDisplay.configure(fileNavigator: explorerNavigator)
        }
    }
}
