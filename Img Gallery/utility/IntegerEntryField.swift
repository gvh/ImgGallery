//
//  IntegerEntryField.swift
//  ImgGallery
//
//  Created by Gardner von Holt on 7/23/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct NumberEntryField : View {
    @State private var enteredValue : String = ""
    @Binding var value : Double

    var body: some View {
        return TextField("", text: $enteredValue)
            .onReceive(Just(enteredValue)) { typedValue in
                if let newValue = Double(typedValue) {
                    self.value = newValue
                }
            }.onAppear(perform:{self.enteredValue = "\(self.value)"})
    }
}
