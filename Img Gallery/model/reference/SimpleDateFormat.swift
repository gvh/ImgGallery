//
//  SimpleDateFormat.swift
//  MediaBrowserMobile
//
//  Created by Gardner von Holt on 11/23/20.
//

import Foundation

struct SimpleDateFormat: HasDateFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
}
