//
//  NSDate+ NSDateFormatter.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

extension Date {
    /**
     Create a date from specified parameters
    
     - Parameters:
       - year: The desired year
       - month: The desired month
       - day: The desired day
     - Returns: A `Date` object
    */
    static func from(year: Int, month: Int, day: Int, hour: Int?, minute: Int?) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        if let hour = hour {
            dateComponents.hour = hour
        }
        if let minute = minute {
            dateComponents.minute = minute
        }
        return calendar.date(from: dateComponents) ?? nil
    }
}
