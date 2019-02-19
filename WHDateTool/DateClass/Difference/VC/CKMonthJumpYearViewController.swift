//
//  CKMonthJumpYearViewController.swift
//  DateCalculator
//
//  Created by Ntgod on 2019/2/12.
//  Copyright © 2018年 Mary Kira. All rights reserved.
//

import Foundation
//
import UIKit
import EventKit

class CKMonthJumpYearViewController: UIViewController, UITextFieldDelegate {
    
    @objc var eventStore : EKEventStore!
    @objc var calendar: EKCalendar!
    
    @objc var datePicker: UIDatePicker!
    @objc var textField: UITextField!
    @objc var eventCalendario: UITextField!
    @objc var titleEvent: UITextField!
    
    func saveCalendar(_ sender: UIButton) {
        let calendar = EKCalendar(for: EKEntityType.event, eventStore: eventStore)
        eventStore.requestAccess(to: EKEntityType.event, completion: {(granted,error) in
            if(granted == false){
                print("Access Denied")
            } else{
                var auxiliar = self.eventStore.sources
                calendar.source = auxiliar[0]
                calendar.title = self.textField.text!
                print(calendar.title)
                
                try! self.eventStore.saveCalendar(calendar, commit: true)
            }
        })
    }
    
    @IBAction func saveEvent(_ sender: UIButton) {
        eventStore.requestAccess(to: EKEntityType.event, completion: {(granted,error) in
            if(granted == false){
                print("Access Denied")
            }
            else{
                let arrayCalendars = self.eventStore.calendars(for: EKEntityType.event)
                var theCalendar: EKCalendar!
                for calendario in arrayCalendars{
                    if(calendario.title == self.eventCalendario.text){
                        theCalendar = calendario
                        print(theCalendar.title)
                    }
                }
                if(theCalendar != nil){
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = self.titleEvent.text!
                    event.startDate = self.datePicker.date
                    event.endDate = self.datePicker.date.addingTimeInterval(3600)
                    event.calendar = theCalendar
                    do {
                        try! self.eventStore.save(event, span: .thisEvent)
                        let alert = UIAlertController(title: "Calendar", message: "Event created \(event.title) in \(theCalendar.title)", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.default, handler: nil))
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                }
                else{
                    print("No calendar with that name")
                }
            }
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventStore = EKEventStore()
        
        let tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CKMonthJumpYearViewController.dismissKeyBoard))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyBoard() {
        self.textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    //called when users tap out of textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
