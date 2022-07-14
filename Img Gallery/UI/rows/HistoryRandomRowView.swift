//
//  HistoryRandomRowView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/24/22.
//

import SwiftUI

struct HistoryRandomRowView: View {
    @EnvironmentObject var historyNavigator: HistoryNavigator

    var body: some View {
        VStack {
            NavigationLink{
                ImageDisplayView(file: historyNavigator.getRandomFile(), isRandom: true)
            } label : {
                Image(uiImage: UIImage(named: "Random")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
