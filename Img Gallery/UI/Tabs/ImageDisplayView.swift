//
//  ImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ImageDisplayView: View {
    @EnvironmentObject var imageDisplay: ImageDisplay
    @ObservedObject var file: ImageFile

    var body: some View {
        VStack {
            HStack {
                Text(imageDisplay.directoryName)
                Spacer()
                Text("\(imageDisplay.fileSequence) of \(imageDisplay.fileCount)")
            }
            Image(uiImage: imageDisplay.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            HStack {
                NavigationLink(destination: FullScreenImageView()) {
                    Text("Full")
                }

                Button("Back") {
                    imageDisplay.fileDataSource?.doPrev()
                }
                .disabled(!imageDisplay.hasBackButtonVar)

                Button("Next") {
                    imageDisplay.fileDataSource?.doNext()
                }
                .disabled(!imageDisplay.hasNextButtonVar)

                Button("Fav") {
                    imageDisplay.fileDataSource?.getCurrentFile().toggleFavorite()
                }

                Button("Save") {
                    imageDisplay.fileDataSource?.doSave(file: (imageDisplay.fileDataSource?.getCurrentFile())!)
                }
                .disabled(!imageDisplay.hasSaveButtonVar)

                Button("GoTo") {
                    imageDisplay.fileDataSource?.doPrev()
                }
                .disabled(!imageDisplay.hasGoToButtonVar)

                Button("Pause") {
                    imageDisplay.fileDataSource?.togglePlayPause()
                }
                .disabled(!imageDisplay.hasPlayPauseButtonVar )
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear() {
            let explorerFileViewer = ExplorerFileViewer.create(file: file)
            imageDisplay.setDataSource(fileDataSource:explorerFileViewer)
            imageDisplay.fileDataSource?.setCurrentFile(file: file)
        }
    }
}
