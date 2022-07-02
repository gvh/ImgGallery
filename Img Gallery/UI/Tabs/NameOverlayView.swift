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
                Text("\(imageDisplay.directoryName) : \(imageDisplay.fileSequence) of \(imageDisplay.fileCount)")
            }
            .font(.callout)
            .foregroundColor(.white)
        }.background(Color.black)
            .opacity(0.55)
            .cornerRadius(10.0)
    }
}
