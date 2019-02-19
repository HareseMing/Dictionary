//
//  CKWeekMonthYearViewController.swift
//  DateCalculator
//
//  Created by Ntgod on 2019/2/12.
//  Copyright © 2018年 Mary Kira. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var dc_penguinView: UIImageView!
    
    @objc var frames: NSArray?
    var dieCenter: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

   
        
        //longPress
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_:)))
        view.addGestureRecognizer(longPress)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func walkLeft(_ send: UIGestureRecognizer) {
        print("walk left");
        //CHECK IF OUT OF SCREEN
        if (dc_penguinView.center.x < 0.0) {
            dc_penguinView.center = CGPoint(x: view.frame.size.width, y: dc_penguinView.center.y);
        }
        
        //FLIP AROUND FOR WALKING LEFT
        self.dc_penguinView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        
        //START WALK ANIMATION
        dc_penguinView.startAnimating()
        
        //MOVE THE IMAGE VIEW TO LEFT
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            self.dc_penguinView.center = CGPoint(x: self.dc_penguinView.center.x - 30, y: self.dc_penguinView.center.y);
        })
    }
    
    @objc func walkRight(_ send: UIGestureRecognizer) {
        print("walk right");
        if (self.dc_penguinView.center.x > self.view.frame.size.width) {
            self.dc_penguinView.center = CGPoint(x: 0, y: self.dc_penguinView.center.y);
        }
        
        self.dc_penguinView.transform = CGAffineTransform.identity;
        dc_penguinView.startAnimating()
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            self.dc_penguinView.center = CGPoint(x: self.dc_penguinView.center.x + 30, y: self.dc_penguinView.center.y)
        })
    }
    
    @objc func jump(_ send: UIGestureRecognizer) {
        dc_penguinView.startAnimating()
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.dc_penguinView.center = CGPoint(x: self.dc_penguinView.center.x, y: self.dc_penguinView.center.y - 50)
        }, completion: { (finished: Bool) -> Void in
            self.jumpBack()
        })
    }
    
    @objc func jumpBack() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            
            self.dc_penguinView.center = CGPoint(x: self.dc_penguinView.center.x, y: self.dc_penguinView.center.y + 50)
        })
    }
    
    @objc func longPress(_ send: UIGestureRecognizer) {
        if(send.state == .began) {
            UIView.animate(withDuration: 0.33, animations: { () -> Void in
                self.dieCenter = self.dc_penguinView.center
                
                
                self.dc_penguinView.center = CGPoint(x: self.dc_penguinView.center.x, y: self.view.frame.size.height)
            }, completion: { (finished: Bool) -> Void in
                
                
                self.longPressBack()
            })
        }
    }
    
    @objc func longPressBack() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            
            
            self.dc_penguinView.center = self.dieCenter!
        })
    }
    
}
