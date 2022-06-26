//
//  FileImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct FileImageView: View {
    @ObservedObject var file: ImageFile

    var body: some View {
        //                        file.getDisplayImage()
        VStack {
            Text("Image: \(file.name)")
            Image(uiImage: file.image)
                .resizable()
                .scaledToFit()
                .frame(width: 250.0, height: 250.0)
        }
        .onAppear() {
            file.getDisplayImage()
        }
    }
}
