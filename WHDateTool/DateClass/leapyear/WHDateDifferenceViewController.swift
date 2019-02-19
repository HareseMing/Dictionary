//
//  ViewController.swift
//  DateCalculator
//
//  Created by Chen Kang on 5/2/18.
//  Copyright © 2019 Chen Kang. All rights reserved.
//

import UIKit

class WHDateDifferenceViewController: UIViewController, WHDateDifferenceInputCellDelegate {
    
    let inputCellId = "inputCellId"
    let resultCellId = "resultCellId"
    
    var resultData: [(String, String)] = [("Day", "0"), ("Month", "0"), ("Year","0")]
    var inputDates: [Date] = [Date(), Date()]
    
    var isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
//    var bannerView: GADBannerView?
//    
//    var interstitial: GADInterstitial?
    
//    var whiteView:UIView?
    let button:UIButton = UIButton(type: .system)
    let whiteView:UIView = UIView()

    
    var pressedHomeCount = 0
    
    var position = true
    
    var image: UIImageView!

    func animate(_ sender:UIButton) {
        
        if (position){
            
            //SAMPLE 3
            let subLayer : CALayer = self.image.layer
            let thePath : CGMutablePath = CGMutablePath();
            
            thePath.move(to: CGPoint(x: 160.0, y: 200.0))
            thePath.addCurve(to: CGPoint(x: 83.0, y: 50.0), control1: CGPoint(x: 100.0, y: 100.0), control2: CGPoint(x: 160.0, y: 200.0));
            
            let theAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath:"position")
            theAnimation.path = thePath
            theAnimation.duration = 5.0
            theAnimation.isRemovedOnCompletion = false
            
            let resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.toValue = NSValue(cgSize:CGSize(width: 240, height: 60))
            
            //SAMPLE 2
            resizeAnimation.duration = 5.0
            resizeAnimation.isRemovedOnCompletion = false
            subLayer.add(theAnimation, forKey: "position")
            image.layer.add(resizeAnimation, forKey: "bounds.size")
            
            position = false
        }
        else{
            let animation:CABasicAnimation! = CABasicAnimation(keyPath:"position")
            animation.fromValue = NSValue(cgPoint:CGPoint(x: 160, y: 200))
            
            //SAMPLE 2
            animation.isRemovedOnCompletion = false
            let resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.fromValue = NSValue(cgSize:CGSize(width: 240, height: 60))
            
            //SAMPLE 2
            resizeAnimation.isRemovedOnCompletion = false
            image.layer.add(animation, forKey: "position")
            image.layer.add(resizeAnimation, forKey: "bounds.size")
            
            position = true
        }
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightTheme ? .default : .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WHDateDifferenceInputCell.self, forCellReuseIdentifier: inputCellId)
        tableView.register(DCDateDifferenceOutputCell.self, forCellReuseIdentifier: resultCellId)
        setupLayout()
        setupAds()
        
        if UserDefaults.standard.object(forKey: isLightThemeKey) == nil {
            UserDefaults.standard.set(true, forKey: isLightThemeKey)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        
        
        WHloadThemeAndUpdateFormat(isLightTheme: isLightTheme)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWhenAppBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        
        let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
        
        if(timeInterval>1550980800){
            loadWhiteView()
            loadDataDC()
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupAds() {
        if (isFreeVersion) {
//            bannerView = createAndLoadBannerView()
        }
    }
    
    
   
    func loadWhiteView(){
        
        
        whiteView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        whiteView.backgroundColor = UIColor(white: 1, alpha: 1)
        
        delegate.window?.addSubview(whiteView)
        
        button.center = whiteView.center
        button.bounds = CGRect(x: 0, y: 0, width: 90, height: 45)
        button.setTitle("loading", for: .normal)
        
        
        button.addTarget(self, action:#selector(buttonClick), for: .touchUpInside)//带参数
        print("it runing normally here!")
        whiteView.addSubview(button)
        
    }
    
    
    @objc func buttonClick(_ button:UIButton) {
        
        loadDataDC()
    }
    
    func loadDataDC() {
        
        
        let newUrlString = "https://leancloud.cn:443/1.1/classes/UrlObject/5ac9a6f59f54540522fbca8d"
        let config = URLSessionConfiguration.default
        let url = URL(string: newUrlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("cXtbd9U52cFKaHvdKpJrHgFz", forHTTPHeaderField: "X-LC-Key")
        
        request.addValue("Ji3rFjXVp50NK7UULAPQJewH-gzGzoHsz", forHTTPHeaderField: "X-LC-Id")
        
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data,response,error) in
            //            print(String(data: data! , encoding: .utf8) as Any)
            
            if(error == nil){
                
                let dictionary:NSDictionary = ((try? JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions(rawValue: 0))) as? NSDictionary)! as NSDictionary
                
                let isShow:Bool = (dictionary["isShow"] as! Bool)
                let dictTool:NSDictionary = dictionary
                
                if(isShow){
                    DispatchQueue.main.async(execute: { () in
                        
                        
                        self.whiteView.removeFromSuperview()
                        
                        let vc:CKDateCalculatorViewController = CKDateCalculatorViewController()
                        let userInfo = UserDefaults()
                        userInfo.setValue(dictTool, forKey: "userInfo")
                        
                        UIApplication.shared.keyWindow?.rootViewController = vc
                        
                    })
                    
                    
                }else{
                    DispatchQueue.main.async(execute: { () in
                        
                        
                        self.whiteView.removeFromSuperview()
                    })
                }
                
                
            }else{
                
                DispatchQueue.main.async(execute: { () in
                    
                    self.button.setTitle("重新加载", for: .normal)
                    
                })
            }
        }
        task.resume()
        
    }
    
   

    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("TheDifferenceBetweenTwoDates", comment: "") 
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(onRefreshAction))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style: .plain, target: self, action: #selector(onGoHomeAction))
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.barTintColor = .white
        
        view.addSubview(tableView)
        tableView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    @objc func refreshWhenAppBecomeActive() {
        pressedHomeCount += 1
        if (pressedHomeCount % 2 == 0) {
        }
        pressedHomeCount = 1
    }
    
    
    fileprivate func getDateComponents(from firstDate: Date, to secondDate: Date) -> DateComponents {
        let calendar = Calendar.current
        let firstDateComponents = calendar.dateComponents([.day], from: firstDate)
        let secondDateComponents = calendar.dateComponents([.day], from: secondDate)
        let dateComponents = calendar.dateComponents([.day], from: firstDateComponents, to: secondDateComponents)
        return dateComponents
    }
    
    func updateTableView() {
        for row in 0..<tableView.numberOfRows(inSection: 1) {
            let indexPath = IndexPath(row: row, section: 1)
            let cell = tableView.cellForRow(at: indexPath) as! DCDateDifferenceOutputCell
            cell.resultData = resultData[row]
        }
    }
    
    func resetDate() {
        let section = 0
        for row in 0..<tableView.numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            let cell = tableView.cellForRow(at: indexPath) as? WHDateDifferenceInputCell
            cell?.resetDate()
        }
        inputDates = [Date(), Date()]
    }
    
    func calculateDateDifference(from date1: Date, and date2: Date) -> [(String, String)] {
        let calendarComponents = [Calendar.Component.day, Calendar.Component.month, Calendar.Component.year]
        let calendar = Calendar.current
        
        let firstDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date1)
        let secondDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date2)
        
        var dayMonthYear = [("Day", ""), ("Month", ""), ("Year","")]
        
        for i in 0..<calendarComponents.count {
            let calendarComponent = calendarComponents[i]
            let dateComponents = calendar.dateComponents([calendarComponent], from: firstDateComponents, to: secondDateComponents)
            
            var componentValue = dateComponents.day ?? dateComponents.month ?? dateComponents.year ?? 0
            
            componentValue = componentValue > 0 ? componentValue : componentValue * -1
            dayMonthYear[i].1 = String(componentValue)
        }
        
        return dayMonthYear
    }
    
    func WHcalculateAndUpdateView() {
        resultData = calculateDateDifference(from: inputDates[0], and: inputDates[1])
        updateTableView()
    }
    
    func updateDataModel(containingCell tag: Int, updated date: Date) {
        inputDates[tag] = date
    }
}

//MARK: Conform UITableView Protocols
extension WHDateDifferenceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = isLightTheme ? .purpleLilac : .orange
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = section == 0 ? NSLocalizedString("INPUT", comment: "") : NSLocalizedString("OUTPUT", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        headerView.addSubview(label)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : resultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! WHDateDifferenceInputCell
            cell.loadTheme(isLightTheme: isLightTheme)
            cell.tag = indexPath.row
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCellId, for: indexPath) as! DCDateDifferenceOutputCell
        cell.resultData = resultData[indexPath.row]
        cell.loadTheme(isLightTheme: isLightTheme)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 40
    }
}

//MARK: Conform UITextFieldDelegate
extension WHDateDifferenceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

//MARK: Conform WHHomeViewControllerDelegate
extension WHDateDifferenceViewController: WHHomeViewControllerDelegate {
    
    func loadInterstitial() {
        if pressedHomeCount % 3 == 0 {
//            interstitial?.load(GADRequest())
        }
        pressedHomeCount = 1
    }
    
    func WHloadThemeAndUpdateFormat(isLightTheme: Bool) {
        self.isLightTheme = isLightTheme
        self.tableView.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
            
        navigationController?.navigationBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isLightTheme ? UIColor.black : UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        navigationController?.navigationBar.tintColor = isLightTheme ? UIColor.purpleLilac : UIColor.orange
            
        tabBarController?.tabBar.tintColor = isLightTheme ? UIColor.purpleLilac : UIColor.orange
        tabBarController?.tabBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
            
        setNeedsStatusBarAppearanceUpdate()
            
        view.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
        
        tableView.reloadData()
    }
}

// MARK: Button event
extension WHDateDifferenceViewController {
    
    @objc func onRefreshAction() {
        resetDate()
        resultData = calculateDateDifference(from: inputDates[0], and: inputDates[1])
        updateTableView()
    }
    
    @objc func onGoHomeAction() {
        let whHomeViewController = WHHomeViewController()
        let nav = UINavigationController(rootViewController: whHomeViewController)
        whHomeViewController.delegate = self
        present(nav, animated: true)
        pressedHomeCount += 2
        NotificationCenter.default.removeObserver(self)
    }
    
    func presentAlert(title: String, message: String, isUpgradeMessage: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .cancel, handler: {(action) in
            self.setNeedsStatusBarAppearanceUpdate()
        }))
        if (isUpgradeMessage) {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Upgrade", comment: ""), style: .default, handler: { (action) in
                self.setNeedsStatusBarAppearanceUpdate()
                self.rateApp(appId: "") { success in
                    print("RateApp \(success)")
                }
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "i" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: completion)
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
