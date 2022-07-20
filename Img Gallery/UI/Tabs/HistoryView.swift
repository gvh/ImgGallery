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
                        HistoryRandomRowView()
                        ForEach(histories.items, id: \.self) { history in
                            HistoryImageRowView(file: history.file, fileSequence: -3, fileCount: histories.items.count)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear() {
        }
    }
}
