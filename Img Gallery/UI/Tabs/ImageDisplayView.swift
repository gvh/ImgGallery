//
//  ImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ImageDisplayView: View {
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var imageDisplay: ImageDisplay
    @ObservedObject var file: ImageFile

    var body: some View {
        VStack {
            Image(uiImage: imageDisplay.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(NameOverlayView(), alignment: SettingsStore.alignmentDecode(alignmentChoice: settings.alignment))
                .padding(.bottom, 5)

            HStack {
                Group {
                    NavigationLink(destination: FullScreenImageView()) {
                        Text("Full")
                    }

                    Spacer()

                    Button("Back") {
                        imageDisplay.fileDataSource?.doPrev()
                    }
                    .disabled(!imageDisplay.hasBackButtonVar)

                    Spacer()

                    Button("Next") {
                        imageDisplay.fileDataSource?.doNext()
                    }
                    .disabled(!imageDisplay.hasNextButtonVar)

                    Spacer()

                    Button("Fav") {
                        imageDisplay.fileDataSource?.getCurrentFile().toggleFavorite()
                    }
                }
                Group {
                    Spacer()

                    Button("Save") {
                        imageDisplay.fileDataSource?.doSave(file: (imageDisplay.fileDataSource?.getCurrentFile())!)
                    }
                    .disabled(!imageDisplay.hasSaveButtonVar)

                    Spacer()

                    Button("GoTo") {
                        imageDisplay.fileDataSource?.doPrev()
                    }
                    .disabled(!imageDisplay.hasGoToButtonVar)

                    Spacer()

                    Button("Pause") {
                        imageDisplay.fileDataSource?.togglePlayPause()
                    }
                    .disabled(!imageDisplay.hasPlayPauseButtonVar )
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 5)
        }
        .onAppear() {
            let explorerFileViewer = ExplorerFileViewer.create(file: file)
            imageDisplay.setDataSource(fileDataSource:explorerFileViewer)
            imageDisplay.fileDataSource?.setCurrentFile(file: file)
        }
    }
}
