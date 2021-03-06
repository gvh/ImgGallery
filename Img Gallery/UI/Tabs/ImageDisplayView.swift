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
    @EnvironmentObject var folderDisplay: FolderDisplay

    @StateObject var fileNavigator: FileNavigator
    @ObservedObject var file: ImageDisplay

    var body: some View {
        VStack {
            Text(imageDisplay.directoryName)
            if AppData.sharedInstance.navigationDisplay.hasResultButtons {
                HStack {
                    Button("<< Prev Result") {
                        AppData.sharedInstance.folderNavigator?.doPrevResult()
                    }
                    Spacer()
                    if Heartbeat.sharedInstance.isTimerActive {
                        Button("Stop") {
                            AppData.sharedInstance.fileNavigator?.togglePlayPause()
                        }
                    } else {
                        Button("Random") {
                            AppData.sharedInstance.fileNavigator?.togglePlayPause()
                        }
                    }
                    Spacer()
                    Button("Next Result >>") {
                        AppData.sharedInstance.folderNavigator?.doNextResult()
                    }
                }
            } else {
                Spacer()
                HStack {
                    if Heartbeat.sharedInstance.isTimerActive {
                        Button("Stop") {
                            AppData.sharedInstance.fileNavigator?.togglePlayPause()
                        }
                    } else {
                        Button("Random") {
                            AppData.sharedInstance.fileNavigator?.togglePlayPause()
                        }
                    }
                }
                Spacer()
            }
            HStack {
                Image(uiImage: imageDisplay.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(NameOverlayView(), alignment: SettingsStore.alignmentDecode(alignmentChoice: settings.alignment))
                    .overlay(TimeRemainingView(), alignment: SettingsStore.alignmentDecode(alignmentChoice: .bottomTrailing))
                    .padding(15)
                    .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                        .onEnded { value in
                            let direction = atan2(value.translation.width, value.translation.height)
                            switch direction {
                            case (-Double.pi/4..<Double.pi/4): break
                            case (Double.pi/4..<Double.pi*3/4): AppData.sharedInstance.fileNavigator!.doPrev()
                            case (Double.pi*3/4...Double.pi), (-Double.pi..<(-Double.pi*3/4)): break
                            case (-Double.pi*3/4..<(-Double.pi/4)): AppData.sharedInstance.fileNavigator!.doNext()
                            default: break
                            }
                        }
                    )
                    .navigationTitle(imageDisplay.name)
            }
        }
        .onAppear() {
            AppData.sharedInstance.fileNavigator?.setCurrentFile(file: file)
            file.getDisplayImage(fileSequence: imageDisplay.fileSequence, fileCount: imageDisplay.fileCount)
        }
        .onChange(of: imageDisplay.fileSequence) {_ in
            print("in on change")
            AppData.sharedInstance.fileNavigator?.setCurrentFile(file: file)
            file.getDisplayImage(fileSequence: imageDisplay.fileSequence, fileCount: imageDisplay.fileCount)
        }
    }
}
