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
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        VStack {
            Image(uiImage: imageDisplay.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(NameOverlayView(), alignment: SettingsStore.alignmentDecode(alignmentChoice: settings.alignment))
        }
    }
}
