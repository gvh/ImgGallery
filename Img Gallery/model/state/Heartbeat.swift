//
//  Heartbeat.swift
//  ImgGallery
//
//  Created by Gardner von Holt on 7/21/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class Heartbeat {
    static var sharedInstance: Heartbeat = Heartbeat()

    var imageChangeTimer: AnyCancellable?
    var progressTimer: AnyCancellable?

    var delegate: HeartbeatDelegate?

    var remainingSecondsBeforeExpire: Double = 0
    var stopRequested: Bool = false

    var isTimerActive: Bool {
        get { return progressTimer != nil }
    }

    func startTimer(delegate: HeartbeatDelegate) {
        print("Starting timer")
        self.stopRequested = false
        self.delegate = delegate
        self.createImageChangeTimer()
        AppData.sharedInstance.imageDisplay.isTimerActive = true
    }

    func stopTimer() {
        print("stopping timer")
        self.stopRequested = true
        AppData.sharedInstance.imageDisplay.isTimerActive = false
    }

    func removeAllTimers() {
        print("removing all timers")
        self.removeProgressTimer()
        self.removeImageChangeTimer()
        self.delegate = nil
        self.stopRequested = false
    }

    func createImageChangeTimer() {
        print("About to create image change timer")
        self.imageChangeTimer = Timer.publish(every: AppData.sharedInstance.settingsStore.secondsBetweenChanges, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                print("Fire image change timer")
                if self.stopRequested {
                    self.removeAllTimers()
                    return
                }

                if AppData.sharedInstance.settingsStore.secondsBetweenChanges == 0 {
                    print("Image change Beat no progress timer")
                    self.delegate?.onBeat()
                } else {
                    print("Image change Beat with progress timer")
                    self.removeProgressTimer()
                    self.delegate?.onBeat()
                    self.createProgressTimer()
                }
            }
        self.createProgressTimer()
        print("Created image change timer")
    }

    func removeImageChangeTimer() {
        print("Remove image change timer")
        self.imageChangeTimer?.cancel()
        self.imageChangeTimer = nil
        self.remainingSecondsBeforeExpire = 0
    }

    func createProgressTimer() {
        if AppData.sharedInstance.settingsStore.secondsBetweenChanges > 0 {
            print("Create progress timer")
            self.remainingSecondsBeforeExpire = AppData.sharedInstance.settingsStore.secondsBetweenChanges
            self.progressTimer = Timer.publish(every: Double(AppData.sharedInstance.settingsStore.secondsBetweenCountdown), on: .main, in: .default)
                .autoconnect()
                .sink { _ in
                    print("Fire progress timer: \(self.remainingSecondsBeforeExpire)")
                    if self.stopRequested {
                        self.removeAllTimers()
                        return
                    }

                    self.remainingSecondsBeforeExpire -= AppData.sharedInstance.settingsStore.secondsBetweenCountdown
                    AppData.sharedInstance.imageDisplay.countDownSeconds = self.remainingSecondsBeforeExpire
                    if self.remainingSecondsBeforeExpire <= 0 {
                        print("Complete progress timer")
                        self.removeProgressTimer()
                    }
                }
        } else {
            print("Do not create progress timer")
            self.progressTimer = nil
        }
    }

    func removeProgressTimer() {
        print("Remove progress timer")
        self.progressTimer?.cancel()
        self.progressTimer = nil
    }
}

