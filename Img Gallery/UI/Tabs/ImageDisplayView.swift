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
            HStack {
                if file.isFavorite {
                    Button(role: .destructive, action: { imageDisplay.navigator?.getCurrentFile()!.toggleFavorite() }) {
                        Label("Fav", systemImage: "heart")
                    }
                    .imageScale(.large)
                } else {
                    Button(role: .destructive, action: { imageDisplay.navigator?.getCurrentFile()!.toggleFavorite() }) {
                        Label("Fav", systemImage: "heart.fill")
                    }
                    .imageScale(.large)
                }

                Spacer()

                Button(role: .destructive, action: { imageDisplay.navigator?.doSave() }) {
                    Label("Save", systemImage: "square.and.arrow.down.fill")
                }

                Spacer()

                if AppData.sharedInstance.isTimerActive {
                    Button(role: .destructive, action: { imageDisplay.navigator?.togglePlayPause() }) {
                        Label("Pause", systemImage: "pause.fill")
                    }
                    .imageScale(.large)
                } else {
                    Button(role: .destructive, action: { imageDisplay.navigator?.togglePlayPause() }) {
                        Label("Play", systemImage: "play.fill")
                    }
                    .imageScale(.large)
                }

                Button("GoTo") {
                    imageDisplay.navigator?.doPrev()
                }
                .disabled(!imageDisplay.hasGoToButtonVar)
            }
            .imageScale(.large)
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
            }
        }
        .onAppear() {
            imageDisplay.navigator?.setCurrentFile(file: file)
            imageDisplay.setFile(file: file)
        }
    }
}
