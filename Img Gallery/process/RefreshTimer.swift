//
//  RefreshTimer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/4/20.
//

import Foundation
import SwiftUI
import Combine

class RefreshTimer {
    var subscription: AnyCancellable?
    var progress: AnyCancellable?

    var viewer: FileDataSource?

    var remainingSecondsBeforeExpire: Int = 0
    var stopRequested: Bool = false

    func startTimer(viewer: FileDataSource) {
        self.stopRequested = false
        self.viewer = viewer
        self.createSubscriptionTimer()
    }

    func stopTimer() {
        self.stopRequested = true
    }

    func removeAllTimers() {
        self.removeProgressTimer()
        self.removeSubscriptionTimer()
        self.viewer = nil
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

                if Int(AppData.sharedInstance.settingsStore.secondsBetweenChanges) == 0 {
                    _ = self.viewer!.onSubscriptionTimer()
                } else {
                    self.removeProgressTimer()
                    _ = self.viewer!.onSubscriptionTimer()
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
        if Int(AppData.sharedInstance.settingsStore.secondsBetweenChanges)! > 0 {
            self.remainingSecondsBeforeExpire = Int(AppData.sharedInstance.settingsStore.secondsBetweenChanges)!
            self.progress = Timer.publish(every: Double(AppData.sharedInstance.settingsStore.secondsBetweenCountdown)!, on: .main, in: .default)
                .autoconnect()
                .sink { _ in
                    if self.stopRequested {
                        self.removeAllTimers()
                        return
                    }

                    self.remainingSecondsBeforeExpire -= Int(AppData.sharedInstance.settingsStore.secondsBetweenCountdown)!
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
