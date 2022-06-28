//
//  ImageDisplay.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/28/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI

class ImageDisplay : ObservableObject {

    @Published var name: String = ""
    @Published var image: UIImage = UIImage(systemName: "film")!

    @Published var directoryName: String = ""
    @Published var fileSequence: Int = -1
    @Published var fileCount: Int = -2

    @Published var hasBackButtonVar: Bool = false
    @Published var hasNextButtonVar: Bool = false
    @Published var asSaveButtonVar: Bool = false
    @Published var hasGoToButtonVar: Bool = false
    @Published var hasPlayPauseButtonVar: Bool = false
    
}
