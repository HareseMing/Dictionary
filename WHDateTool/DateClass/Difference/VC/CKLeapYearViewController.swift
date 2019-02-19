//
//  CKLeapYearViewController.swift
//  DateCalculator
//
//  Created by Chen Kang on 5/15/18.
//  Copyright © 2019 Chen Kang. All rights reserved.
//

import UIKit

class CKLeapYearViewController: WHDateDifferenceViewController {
    
    let CKLeapYearOutputCellId = "CKLeapYearOutputCellId"
    var isLeapYear = false
    var cd_checkingYear: Int = 2018
    var pickerView = UIPickerView()
    let toolBar = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("CheckLeapYear", comment: "")
        
        tableView.register(CKLeapYearOutputCell.self, forCellReuseIdentifier: CKLeapYearOutputCellId)
        
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        
        
        pickerView.isUserInteractionEnabled = true
        
        
        let currentDate = Date()
        guard let currentYear = Calendar.current.dateComponents([.year], from: currentDate).year else { return }
        isLeapYear = checkLeapYear(year: currentYear)
        
        
        cd_checkingYear = currentYear
    }
    
    override func setupAds() {
        // Does nothing
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (isFreeVersion) {
            
            presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("MessageUp", comment: ""), isUpgradeMessage: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! WHDateDifferenceInputCell
            cell.loadTheme(isLightTheme: isLightTheme)
            cell.tag = indexPath.row
            
            //        cell.backgroundColor = UIColor.white

            cell.disableUserInteraction(isFreeVersion: isFreeVersion)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CKLeapYearOutputCellId, for: indexPath) as! CKLeapYearOutputCell
        cell.loadTheme(isLightTheme: isLightTheme)
        cell.checkingYear_WH = cd_checkingYear
        cell.isLeapYear_WH = isLeapYear
//        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func updateTableView() {
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as? CKLeapYearOutputCell
        cell?.checkingYear_WH = cd_checkingYear
        cell?.isLeapYear_WH = isLeapYear
        
        //        cell.backgroundColor = UIColor.red

    }
    
    override func updateDataModel(containingCell tag: Int, updated date: Date) {
        guard let currentYear = Calendar.current.dateComponents([.year], from: date).year else { return }
        cd_checkingYear = currentYear
    }
    
    override func WHcalculateAndUpdateView() {
        isLeapYear = checkLeapYear(year: cd_checkingYear)
        updateTableView()
    }
    
    func getWHCurrentYear() -> Int {
        let currentDate = Date()
        guard let currentYear = Calendar.current.dateComponents([.year], from: currentDate).year else { return 0 }
        return currentYear
    }
    
    func checkLeapYear(year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
    
    override func onRefreshAction() {
        resetDate()
        cd_checkingYear = getWHCurrentYear()
        isLeapYear = checkLeapYear(year: cd_checkingYear)
        updateTableView()
    }
}
