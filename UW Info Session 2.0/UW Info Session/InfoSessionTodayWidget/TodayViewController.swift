//
//  TodayViewController.swift
//  InfoSessionTodayWidget
//
//  Created by Qiu Zefeng on 2015-09-12.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var showDetailButton: UIButton!
    @IBOutlet weak var todayDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var todayInfoSessionContent: UILabel!
    @IBOutlet weak var todaySummary: UILabel!
   
    var isTodayDetailVisible = true
    
    var todayClient = TodayClient()
    var todayInfoSessions = [InfoSessionUnit()]
    var todayString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        todayDetailHeight.constant = 100
        self.preferredContentSize = CGSizeMake(0, 150)
        todaySummary.text = "Loading ..."
        
        todayClient.updateFromSourceURLForToday(2015, month: .Sep){
            (result: Bool) in
            println("got back: \(result)")
            
            self.todayInfoSessions = TodayInfoSession.shareInstance.InfoSessions
            var sum = self.todayInfoSessions.count
            
            if sum == 0{
                self.todaySummary.text = "No Info Session Today"
                self.preferredContentSize = CGSizeMake(0, 50)
            }else {
                let transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
                self.showDetailButton.transform = transform
                if sum == 1 {
                    self.todaySummary.text = "There is 1 Info Session today"
                }else {
                    self.todaySummary.text = "There are \(sum) Info Session Today"
                }
                
                for info in self.todayInfoSessions {
                    self.todayString = self.todayString + info.employer + ",  "
                }
                self.todayString = self.todayString + "in campus."
                self.todayInfoSessionContent.text = self.todayString
            }
        }
    }
    
    @IBAction func showNumberOfInfoSession(sender: UIButton) {
        if isTodayDetailVisible {
            self.preferredContentSize = CGSizeMake(0, 50)
            todayDetailHeight.constant = 0
            let transform = CGAffineTransformMakeRotation(0)
            showDetailButton.transform = transform
            isTodayDetailVisible = false
        }else {
            self.preferredContentSize = CGSizeMake(0, 150)
            todayDetailHeight.constant = 100
            let transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            showDetailButton.transform = transform
            isTodayDetailVisible = true
        }
    }
    
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}













