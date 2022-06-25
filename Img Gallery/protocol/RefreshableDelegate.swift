//
//  RefreshableDelegate.swift
//  Movey Maint
//
//  Created by Gardner von Holt on 11/30/19.
//  Copyright © 2019 Gardner von Holt. All rights reserved.
//

import Foundation

protocol RefreshableDelegate: AnyObject {
    func onDataChanged()
}
