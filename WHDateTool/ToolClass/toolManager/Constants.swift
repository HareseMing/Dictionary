//
//  Constants.swift
//  DateCalculator
//
//  Created by Chen Kang on 15/10/18.
//  Copyright © 2019 Chen Kang. All rights reserved.
//

import Foundation

let isFreeVersion: Bool = false
let isLightThemeKey: String = "isLightTheme"


enum Weekday: Int {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    func getLMStringValue() -> String {
        switch self {
        case .Sunday:
            return "Sunday"
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        }
    }
}
