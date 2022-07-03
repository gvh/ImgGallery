//
//  ImageMenuView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/25/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct ImageMenuView: View {
    @ObservedObject var folder: ImageFolder

    let columns = [GridItem(.adaptive(minimum: 150, maximum: 250))]

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                Text(folder.noPrefixName)
                LazyVGrid(columns: columns) {
                    ForEach(folder.files, id: \.self) { file in
                        FileImageRowView(file: file)
                    }
                }
            }
            .padding()
        }
    }
}
