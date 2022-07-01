//
//  FullScreenImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/27/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct FullScreenImageView: View {
    @EnvironmentObject var imageDisplay: ImageDisplay

    var body: some View {
        VStack {
            Image(uiImage: imageDisplay.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(NameOverlay(), alignment: .bottomLeading)
        }
    }
}

struct NameOverlay: View {
    @EnvironmentObject var imageDisplay: ImageDisplay

    var body: some View {
        ZStack {
            VStack {
                Text(imageDisplay.directoryName)
                    .font(.callout)
                    .padding(6)
                    .foregroundColor(.white)
                Text(imageDisplay.name)
                    .font(.callout)
                    .padding(6)
                    .foregroundColor(.white)
                Text("\(imageDisplay.fileSequence) of \(imageDisplay.fileCount)")
                    .font(.callout)
                    .padding(6)
                    .foregroundColor(.white)
            }
        }.background(Color.black)
            .opacity(0.5)
            .cornerRadius(10.0)
            .padding(10)
    }
}
