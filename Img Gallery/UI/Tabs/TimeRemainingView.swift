//
//  TimeRemainingView.swift
//  ImgGallery
//
//  Created by Gardner von Holt on 7/23/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import SwiftUI

struct TimeRemainingView: View {
    @EnvironmentObject var imageDisplay: ImageDisplay

    var body: some View {
        if Heartbeat.sharedInstance.isTimerActive {
            Text(String(Int(imageDisplay.countDownSeconds)))
        }
    }
}
