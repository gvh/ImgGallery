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
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        let direction = atan2(value.translation.width, value.translation.height)
                        switch direction {
                        case (-Double.pi/4..<Double.pi/4): break
                        case (Double.pi/4..<Double.pi*3/4): imageDisplay.navigator?.doPrev()
                        case (Double.pi*3/4...Double.pi), (-Double.pi..<(-Double.pi*3/4)): break
                        case (-Double.pi*3/4..<(-Double.pi/4)): imageDisplay.navigator?.doNext()
                        default: print("unknown")
                        }
                    }
                )
            HStack {
                Group {
                    NavigationLink(destination: ImageDisplayFullScreenView()) {
                        Text("Full")
                    }

                    Spacer()

                    Button("Back") {
                        imageDisplay.navigator?.doPrev()
                    }
                    .disabled(!imageDisplay.hasBackButtonVar)

                    Spacer()

                    Button("Next") {
                        imageDisplay.navigator?.doNext()
                    }
                    .disabled(!imageDisplay.hasNextButtonVar)

                    Spacer()

                    Button("Fav") {
                        imageDisplay.navigator?.getCurrentFile()!.toggleFavorite()
                    }
                }
                Group {
                    Spacer()

                    Button("Save") {
                        imageDisplay.navigator?.doSave()
                    }
                    .disabled(!imageDisplay.hasSaveButtonVar)

                    Spacer()

                    Button("GoTo") {
                        imageDisplay.navigator?.doPrev()
                    }
                    .disabled(!imageDisplay.hasGoToButtonVar)

                    Spacer()

                    Button("Pause") {
                        imageDisplay.navigator?.togglePlayPause()
                    }
                    .disabled(!imageDisplay.hasPlayPauseButtonVar )
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 5)
        }
        .onAppear() {
            imageDisplay.setFile(file: file)
        }
    }
}
