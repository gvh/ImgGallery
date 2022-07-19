//
//  ImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ImageDisplayView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var imageDisplay: ImageDisplay
    @ObservedObject var file: ImageFile

    var body: some View {
        VStack {
            if AppData.sharedInstance.navigationDisplay.hasResultButtons {
                HStack {
                    Button("<< Prev Result") {
                        imageDisplay.navigator?.doPrevResult()
                    }
                    Spacer()
                    Button("Next Result >>") {
                        imageDisplay.navigator?.doNextResult()
                    }
                }
            }
            HStack {
                Image(uiImage: imageDisplay.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(NameOverlayView(), alignment: SettingsStore.alignmentDecode(alignmentChoice: settings.alignment))
                    .padding(15)
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
                    .navigationTitle(imageDisplay.directoryName)
                    .toolbar {
                        if file.isFavorite {
                            Button("Un Fav") {
                                print("Un Fav tapped!")
                                imageDisplay.navigator?.getCurrentFile()!.toggleFavorite()
                            }
                        } else {
                            Button("Fav") {
                                print("Fav tapped!")
                                imageDisplay.navigator?.getCurrentFile()!.toggleFavorite()
                            }
                        }
                        Button("Save") {
                            print("Save tapped!")
                            imageDisplay.navigator?.doSave()
                        }
                        if imageDisplay.isTimerActive {
                            Button("Pause") {
                                imageDisplay.navigator?.togglePlayPause()
                            }
                        } else {
                            Button("Play") {
                                imageDisplay.navigator?.togglePlayPause()
                            }
                        }
                    }
            }
        }
        .onAppear() {
            AppData.sharedInstance.fileNavigator?.setCurrentFile(file: file)
        }
    }
}
