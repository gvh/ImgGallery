//
//  SettingsView.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/30/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Refresh Settings")) {
                    HStack {
                        Text("Seconds Between Changes")
                        NumberEntryField(value: $settings.secondsBetweenChanges)
                    }
                    HStack {
                        Text("Seconds Between Countdown")
                        NumberEntryField(value: $settings.secondsBetweenCountdown)
                    }
                }
                Section(header: Text("Display Settings")) {
                    Picker(
                        selection: $settings.alignment,
                        label: Text("Label Alignment")
                    ) {
                        ForEach(SettingsStore.AlignmentChoice.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                }
                Section(header: Text("Website Settings")) {
                    HStack {
                        Text("UserName")
                        TextField("UserName", text: $settings.userName)
                    }
                    HStack {
                        Text("Password")
                        TextField("Password", text: $settings.passWord)
                    }
                    HStack {
                        Text("URL")
                        TextField("Base URL", text: $settings.baseURL)
                    }
                }
                Section(header: Text("Search Settings")) {
                    HStack {
                        Text("Ignored Strings")
                        TextField("ignore directories containg text", text: $settings.ignoreFoldersContaining)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarTitle(Text("Settings"))
    }
}
