//
//  WHWeekdayViewController.swift
//  DateCalculator
//
//  Created by Chen Kang on 5/11/18.
//  Copyright © 2019 Chen Kang. All rights reserved.
//

import UIKit

class WHWeekdayViewController: WHDateDifferenceViewController {
    
    let weekdayCelId = "weekdayCellId"

    var weekdayObjs = [WeekdayObj(weekday: Weekday.Sunday, isSelected: true, numOfDays: 0),
                       WeekdayObj(weekday: Weekday.Monday, isSelected: true, numOfDays: 0),
                       WeekdayObj(weekday: Weekday.Tuesday, isSelected: true, numOfDays: 0),
                       WeekdayObj(weekday: Weekday.Wednesday, isSelected: true, numOfDays: 0),
                       WeekdayObj(weekday: Weekday.Thursday, isSelected: true, numOfDays: 0),
                       WeekdayObj(weekday: Weekday.Friday, isSelected: true, numOfDays: 0),
                       WeekdayObj(weekday: Weekday.Saturday, isSelected: true, numOfDays: 0)]
    
    var weekDifference: Int = 0
    var remainingDays: Int = 0
    var totalDays: Int = 0
    //var clickedSwitchTag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //SAMPLE 3
        let thePath : CGMutablePath = CGMutablePath();
        
        thePath.move(to: CGPoint(x: 160.0, y: 200.0))
        thePath.addCurve(to: CGPoint(x: 83.0, y: 50.0), control1: CGPoint(x: 100.0, y: 100.0), control2: CGPoint(x: 160.0, y: 200.0));
        
        let theAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath:"position")
        theAnimation.duration = 5.0
        theAnimation.isRemovedOnCompletion = false
        theAnimation.path = thePath
        
        
        let resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
        
        resizeAnimation.duration = 5.0
        resizeAnimation.isRemovedOnCompletion = false
        resizeAnimation.toValue = NSValue(cgSize:CGSize(width: 240, height: 60))
        
        
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle:UIAlertController.Style.actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("you have pressed the Cancel button");
            
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("you have pressed OK button");
            
        }
        alertController.addAction(OKAction)
        
        
        
        tableView.isScrollEnabled = true
        tableView.register(CKWeedayOutputCell.self, forCellReuseIdentifier: weekdayCelId)
        navigationItem.title = NSLocalizedString("WeekdaysBetweenTwoDates", comment: "")
        WHcalculateAndUpdateView()
        
        
        
    }
    
    override func setupAds() {
        // Does nothing
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (isFreeVersion) {
            
            presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("MessageUp", comment: ""), isUpgradeMessage: true)
        }
    }
    
    override func updateTableView() {
        
        resultData = [("Total days", "\(totalDays)")]
        
        guard let visibleCellIndexPaths = tableView.indexPathsForVisibleRows else { return }
        for i in 0..<visibleCellIndexPaths.count {
            let indexPath = visibleCellIndexPaths[i]
            if indexPath.section == 0 {
                continue
            }
            
            let visibleCell = tableView.cellForRow(at: indexPath)
            if let weekdayCell = visibleCell as? CKWeedayOutputCell {
                weekdayCell.weekdayObj = weekdayObjs[weekdayCell.tag]
                continue
            }
            
            let resultCell = visibleCell as! DCDateDifferenceOutputCell
            resultCell.resultData = resultData[0]
        }
    }
    
    override func WHcalculateAndUpdateView() {
        let dateDifference = super.calculateDateDifference(from: inputDates[0], and: inputDates[1])
        guard let dayDifference = Int(dateDifference[0].1) else {
            return
        }
        weekDifference = dayDifference / 7
        remainingDays = dayDifference % 7
        totalDays = 0
        
        for i in 0..<weekdayObjs.count {
            if !weekdayObjs[i].isSelected {
                continue
            }
            guard let weekday = Weekday.init(rawValue: i + 1) else { return }
            let weekdays = calculateWeekdays(weekday: weekday)
            let weekdayObj = WeekdayObj(weekday: weekday, isSelected: true, numOfDays: weekdays)
            weekdayObjs[i] = weekdayObj
        }
        updateTableView()
    }
    
    func getWeekday(from date: Date) -> Weekday? {
        let dateComponents = Calendar.current.dateComponents([.weekday], from: date)
        guard let weekdayValue = dateComponents.weekday else { return nil }
        guard let weekday = Weekday(rawValue: weekdayValue) else { return nil }
        return weekday
    }
    
    override func onRefreshAction() {
        inputDates = [Date(), Date()]
        for cell in tableView.visibleCells {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            if let cell = cell as? WHDateDifferenceInputCell {
                cell.resetDate()
                continue
            }
            if let cell = cell as? CKWeedayOutputCell {
                guard let weekday = Weekday.init(rawValue: indexPath.row + 1) else { return }
                let resetedWeekdayObj = WeekdayObj(weekday: weekday, isSelected: true, numOfDays: 0)
                weekdayObjs[indexPath.row] = resetedWeekdayObj
                cell.weekdayObj = resetedWeekdayObj
                cell.loadTheme(isLightTheme: isLightTheme)
            }
        }
        WHcalculateAndUpdateView()
    }
}

extension WHWeekdayViewController: WHWeekdaySwitchDelegate {
    
    func calculateWeekdays(weekday: Weekday) -> Int {
        var weekdays = weekDifference
        
        totalDays += weekDifference
        let calendar = Calendar.current
        
        guard let weekdayValue1 = calendar.dateComponents([.weekday], from: inputDates[0]).weekday else { return 0 }
        guard let weekdayValue2 = calendar.dateComponents([.weekday], from: inputDates[1]).weekday else { return 0 }
        
        if weekdayValue2 - weekdayValue1 >= 0 {
            if !(weekdayValue1...weekdayValue2).contains(weekday.rawValue) {
                return weekDifference
            }
        } else {
            if !(weekdayValue1...7).contains(weekday.rawValue) && !(1...weekdayValue2).contains(weekday.rawValue) {
                return weekDifference
            }
        }
        
        
        guard let addingDate = calendar.date(byAdding: .day, value: weekDifference * 7, to: inputDates[0]) else { return 0 }
        guard let addingDateWeekday = calendar.dateComponents([.weekday], from: addingDate).weekday else { return 0 }
        var difference = (weekday.rawValue - addingDateWeekday)
        if difference < 0 {
            difference += 7
        }
        
        guard let dateBetween = calendar.date(byAdding: .day, value: difference, to: addingDate) else { return 0 }
        if dateBetween.isBetween(date1: inputDates[0], date2: inputDates[1]) {
            weekdays += 1
            totalDays += 1
        }

        return weekdays
    }
    
    func updateDataModel(containingCell tag: Int, old weekdayObj: WeekdayObj) {
        
        if !weekdayObj.isSelected {
            let updatedWeekdayObj = WeekdayObj(weekday: weekdayObj.weekday, isSelected: weekdayObj.isSelected, numOfDays: 0)
            weekdayObjs[tag] = updatedWeekdayObj
            totalDays -= weekdayObj.numOfDays
        } else {
            let weekdays = calculateWeekdays(weekday: weekdayObj.weekday)
            let updatedWeekdayObj = WeekdayObj(weekday: weekdayObj.weekday, isSelected: weekdayObj.isSelected, numOfDays: weekdays)
            weekdayObjs[tag] = updatedWeekdayObj
            totalDays += weekdayObj.numOfDays
        }
        updateTableView()
    }
    
}

extension WHWeekdayViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! WHDateDifferenceInputCell
            cell.loadTheme(isLightTheme: isLightTheme)
            cell.tag = indexPath.row
            cell.disableUserInteraction(isFreeVersion: isFreeVersion)
            cell.delegate = self
            return cell
        }
        if indexPath.row < 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: weekdayCelId, for: indexPath) as! CKWeedayOutputCell
            cell.weekdayObj = weekdayObjs[indexPath.row]
            cell.loadTheme(isLightTheme: isLightTheme)
            cell.tag = indexPath.row
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCellId, for: indexPath) as! DCDateDifferenceOutputCell
        cell.resultData = resultData[0]
        cell.loadTheme(isLightTheme: isLightTheme)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 8
    }
}
