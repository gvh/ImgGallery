//
//  ConsoleLogger.swift
//  Movey
//
//  Created by Gardner von Holt on 6/18/22.
//

import Foundation

class ConsoleLogger {

}

extension ConsoleLogger: MessageDisplayer {
    func updateMessage(message: String) {
        print(message)
    }

}
