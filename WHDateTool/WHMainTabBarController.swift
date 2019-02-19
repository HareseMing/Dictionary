//
//  WHMainTabBarController.swift
//  DateCalculator
//
//  Created by Chen Kang on 9/5/18.
//  Copyright © 2019 Chen Kang. All rights reserved.
//

import UIKit

class WHMainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let whDateDifferenceViewController = WHDateDifferenceViewController()
        
        
        let dateDifferenceNav = UINavigationController(rootViewController: whDateDifferenceViewController)
//        dateDifferenceNav = NSLocalizedString("Weekday", comment: "")
//        weekdayNav.tabBarItem.image = #imageLiteral(resourceName: "weekday")
        
        
        
        
        
        
        
        dateDifferenceNav.tabBarItem.title = NSLocalizedString("TheDifference", comment: "")
        dateDifferenceNav.tabBarItem.image = #imageLiteral(resourceName: "difference")
        
        
        
        let whAddSubtractDateViewController = WHAddSubtractDateViewController()
        
        
        let addSubtractDateNav = UINavigationController(rootViewController: whAddSubtractDateViewController)
        addSubtractDateNav.tabBarItem.title = NSLocalizedString("AddOrSubtract", comment: "")
        
        
        
        addSubtractDateNav.tabBarItem.image = #imageLiteral(resourceName: "add-subtract")
        
        let whWeekdayViewController = WHWeekdayViewController()
        
        
        let weekdayNav = UINavigationController(rootViewController: whWeekdayViewController)
        
//        weekdayNav.tabBarItem.title = NSLocalizedString("Weekday", comment: "")
//        weekdayNav.tabBarItem.image = #imageLiteral(resourceName: "weekday")
//
        
        
        weekdayNav.tabBarItem.title = NSLocalizedString("Weekday", comment: "")
        weekdayNav.tabBarItem.image = #imageLiteral(resourceName: "weekday")
        
        let leapYearViewController = CKLeapYearViewController()
        
        
        
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle:UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        
        let leapYearNav = UINavigationController(rootViewController: leapYearViewController)
        
        
        
        leapYearNav.tabBarItem.title = NSLocalizedString("LeapYear", comment: "")
        leapYearNav.tabBarItem.image = #imageLiteral(resourceName: "leapYear")

        viewControllers = [dateDifferenceNav, addSubtractDateNav, weekdayNav, leapYearNav]
    }
}
