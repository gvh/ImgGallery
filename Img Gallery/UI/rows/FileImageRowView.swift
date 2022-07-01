//
//  FileImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct FileImageRowView: View {
    @ObservedObject var file: ImageFile

    var body: some View {
        VStack {
            NavigationLink{
                ImageDisplayView(file: file)
            } label : {
                Image(uiImage: file.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear() {
            file.getDisplayImage()
        }
    }
}
