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

    var subscription: AnyCancellable?
    var progress: AnyCancellable?

    var fileNavigator: FileNavigator?

    var remainingSecondsBeforeExpire: Int = 0
    var stopRequested: Bool = false

    func startTimer(fileNavigator: FileNavigator) {
        self.stopRequested = false
        self.fileNavigator = fileNavigator
        self.createSubscriptionTimer()
    }

    func stopTimer() {
        self.stopRequested = true
    }

    func removeAllTimers() {
        self.removeProgressTimer()
        self.removeSubscriptionTimer()
        self.fileNavigator = nil
        self.stopRequested = false
    }

    func createSubscriptionTimer() {
        self.subscription = Timer.publish(every: Double(AppData.sharedInstance.settingsStore.secondsBetweenChanges)!, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                if self.stopRequested {
                    self.removeAllTimers()
                    return
                }

                if AppData.sharedInstance.settingsStore.secondsBetweenChanges == 0 {
                    _ = self.viewer!.onSubscriptionTimer()
                } else {
                    self.removeProgressTimer()
                    _ = self.fileNavigator!.onSubscriptionTimer()
                    self.createProgressTimer()
                }
            }
        self.createProgressTimer()
    }

    func removeSubscriptionTimer() {
        self.subscription?.cancel()
        self.subscription = nil
        self.remainingSecondsBeforeExpire = 0
    }

    func createProgressTimer() {
        if AppData.sharedInstance.settingsStore.secondsBetweenChanges > 0 {
            self.remainingSecondsBeforeExpire = AppData.sharedInstance.settingsStore.secondsBetweenChanges
            self.progress = Timer.publish(every: Double(AppData.sharedInstance.settingsStore.secondsBetweenCountdown), on: .main, in: .default)
                .autoconnect()
                .sink { _ in
                    if self.stopRequested {
                        self.removeAllTimers()
                        return
                    }

                    self.remainingSecondsBeforeExpire -= AppData.sharedInstance.settingsStore.secondsBetweenCountdown
                    _ = self.viewer!.onProgress(timer: self)
                    if self.remainingSecondsBeforeExpire <= 0 {
                        self.removeProgressTimer()
                    }
                }
        } else {
            self.progress = nil
        }
    }

    func removeProgressTimer() {
        self.progress?.cancel()
        self.progress = nil
    }
}
