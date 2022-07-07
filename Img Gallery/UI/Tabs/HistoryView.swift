//
//  HistoryView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

struct HistoryView: View {

    @ObservedObject var histories: Histories = AppData.sharedInstance.histories
    @EnvironmentObject var historyNavigator: HistoryNavigator

    let columns = [GridItem(.adaptive(minimum: 100, maximum: 300))]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    Text("Browsing History")
                    LazyVGrid(columns: columns) {
                        ForEach(histories.items, id: \.self) { history in
                            HistoriesImageRowView(file: history.file)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear() {
            AppData.sharedInstance.imageDisplay.setNavigator(navigator: historyNavigator)
        }
    }
}
