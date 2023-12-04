//
//  Date+.swift
//  CryptoSphere
//
//  Created by Yago Marques on 03/12/23.
//

import Foundation

extension Date {
    static func oneHourEarlier() -> Date? {
        let currentDate = Date()
        let calendar = Calendar.current
        let component = DateComponents(hour: -1)

        let oneHourEarlier = calendar.date(byAdding: component, to: currentDate)

        return oneHourEarlier
    }
}
