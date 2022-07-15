//
//  NameOverlayView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/2/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct NameOverlayView: View {
    @EnvironmentObject var imageDisplay: ImageDisplay

    var body: some View {
        ZStack {
            VStack {
                Text(imageDisplay.parentDirectoryName)
                Text("\(imageDisplay.directoryName) : \(imageDisplay.fileSequence + 1) of \(imageDisplay.fileCount)")
            }
            .gesture(TapGesture(count: 2)
                .onEnded {
                    print("on tap")
                    imageDisplay.navigator?.doGoTo()
                }
            )
            .font(.callout)
            .foregroundColor(.white)
        }.background(Color.black)
            .opacity(0.55)
            .cornerRadius(10.0)
    }
}
