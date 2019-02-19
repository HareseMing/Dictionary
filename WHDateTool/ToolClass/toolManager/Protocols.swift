//
//  Protocols.swift
//  DateCalculator
//
//  Created by  on 5/8/18.
//  Copyright © 2019 Chen Kang. All rights reserved.
//

import UIKit

protocol HomeViewDelegate: class {
    
    
    func loadTheme(isLightTheme: Bool)

    
    
}

protocol WHHomeViewControllerDelegate: class {
    
    func WHloadThemeAndUpdateFormat(isLightTheme: Bool)
    func loadInterstitial()
}

protocol WHDateDifferenceInputCellDelegate: class {
    func WHcalculateAndUpdateView()
    func updateDataModel(containingCell tag: Int, updated date: Date)
}

protocol WHAddSubtractTableViewCellDelegate: class {
    func WHcalculateAndUpdateView()
    func updateDataModel(dayMonthYear: [Int])
}

protocol WHWeekdaySwitchDelegate: class {
    func updateDataModel(containingCell tag: Int, old weekdayObj: WeekdayObj)
}
