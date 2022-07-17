//
//  HistoryImageRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct HistoryImageRowView: View {
    @EnvironmentObject var historyNavigator: HistoryNavigator
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
            file.getDisplayImage()
        }
    }
}
