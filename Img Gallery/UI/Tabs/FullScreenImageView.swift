//
//  FullScreenImageView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/27/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct FullScreenImageView: View {
    @ObservedObject var fileDataSource: FolderFileViewer

    var body: some View {
        VStack {
            Image(uiImage: fileDataSource.getCurrentFile().image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

