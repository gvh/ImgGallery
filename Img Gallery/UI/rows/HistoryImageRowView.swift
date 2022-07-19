//
//  HistoryImageRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct HistoryImageRowView: View {
    @EnvironmentObject var historyNavigator: HistoryNavigator
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
            historyNavigator.setCurrentFile(file: file)
            file.getDisplayImage()
        }
    }
}
