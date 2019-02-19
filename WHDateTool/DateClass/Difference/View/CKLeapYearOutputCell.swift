//
//  CKLeapYearOutputCell.swift
//  DateCalculator
//
//  Created by Chen Kang on 5/15/18.
//  Copyright © 2019 Chen Kang. All rights reserved.
//

import UIKit

class CKLeapYearOutputCell: UITableViewCell {
    
    var checkingYear_WH: Int? {
        didSet {
            
            
            guard let checkingYear_WH = checkingYear_WH else { return }
            
            textView.text = String(checkingYear_WH)
        }
    }
    
    var isLeapYear_WH: Bool? {
        didSet {
            guard let isLeapYear_WH = isLeapYear_WH else { return }
            let leapYearKey = isLeapYear_WH ? "IsALeapYear" : "IsNotALeapYear";
            let isLeapYear_WHString = NSLocalizedString(leapYearKey, comment: "")
            textView.text! += isLeapYear_WHString
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        //textView.textColor = .purpleLilac
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func loadTheme(isLightTheme: Bool) {
        let textColor: UIColor = isLightTheme ? .black : .white
        let mainBackgroundColor: UIColor = isLightTheme ? .white : .black
       
        textView.backgroundColor = mainBackgroundColor
        textView.textColor = textColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textView)
        textView.constraintTo(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
