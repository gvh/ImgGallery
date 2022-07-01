//
//  RootExplorerView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/26/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct RootExplorerView: View {
    var body: some View {
        NavigationView {
            ExplorerView(folder: (AppData.sharedInstance.downloadTOC?.rootFolder)!)
        }
        .navigationViewStyle(.stack)
    }
}
