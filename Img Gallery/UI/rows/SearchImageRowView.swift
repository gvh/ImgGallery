//
//  SearchImageRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct SearchImageRowView: View {
    @EnvironmentObject var searchNavigator: SearchResultsNavigator
    @ObservedObject var file: ImageDisplay

    var body: some View {
        VStack {
            NavigationLink{
                ImageDisplayView(file: file, isRandom: false)
            } label : {
                Image(uiImage: file.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear() {
            file.currentFile.getDisplayImage()
        }
    }
}
