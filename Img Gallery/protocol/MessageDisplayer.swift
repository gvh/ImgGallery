//
//  MessageDisplayer.swift
//  Movey Maint
//
//  Created by Gardner von Holt on 11/6/21.
//  Copyright © 2021 Gardner von Holt. All rights reserved.
//

import Foundation

protocol MessageDisplayer: AnyObject {
    func updateMessage(message: String)
}
