//
//  CustomDate.swift
//  MediaBrowserMobile
//
//  Created by Gardner von Holt on 11/23/20.
//

import Foundation

struct CustomDate<E: HasDateFormatter>: Codable {

    let value: Date

    init(date: Date) {
        value = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        guard let date = E.dateFormatter.date(from: text) else {
            throw CustomDateError.general
        }
        self.value = date
    }

    enum CustomDateError: Error {
        case general
    }

}
