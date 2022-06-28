//
//  ImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ImageDisplayView: View {
    @ObservedObject var fileDataSource: FolderFileViewer

    var body: some View {
        VStack {
            HStack {
                Text(fileDataSource.getCurrentFile().textDirectoryName)
                Spacer()
                Text("\(fileDataSource.getCurrentFile().subs + 1) of \(fileDataSource.getCurrentFile().parentFolder.files.count)")
            }
            Image(uiImage: fileDataSource.getCurrentFile().image)
                .resizable()
                .aspectRatio(contentMode: .fit)

                NavigationLink(destination: FullScreenImageView(fileDataSource: fileDataSource)) {
                    Text("Full")
                }

                Button("Back") {
                    fileDataSource.doPrev()
                }
                .disabled(!fileDataSource.hasBackButtonVar)

                Button("Next") {
                    fileDataSource.doNext()
                }
                .disabled(!fileDataSource.hasNextButtonVar)

                Button("Fav") {
                    fileDataSource.getCurrentFile().toggleFavorite()
                }

                Button("Save") {
                    fileDataSource.doSave(file: fileDataSource.getCurrentFile())
                }
                .disabled(!fileDataSource.hasSaveButtonVar)

                Button("GoTo") {
                    fileDataSource.doPrev()
                }
                .disabled(!fileDataSource.hasGoToButtonVar)

                Button("Pause") {
                    fileDataSource.togglePlayPause()
                }
                .disabled(!fileDataSource.hasPlayPauseButtonVar )
            }
            .onAppear() {
        }
    }
}
