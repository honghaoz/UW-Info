//
//  DetailViewController.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-11.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController, ProviderSwitchToDetailViewDelegate{
    
    var shouldHide: Bool = true
    
    var infoSession: InfoSessionUnit?
    var alertVisible = false
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
//        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
//        view.addGestureRecognizer(tap)
//        tap.cancelsTouchesInView = false 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        BaseInfoCell.registerInTableView(detailTableView)
        DetailInfoCell.registerInTableView(detailTableView)
        ReminderCell.registerInTableView(detailTableView)
        NoteCell.registerInTableView(detailTableView)
        RSVPCell.registerInTableView(detailTableView)
        AlertCell.registerInTableView(detailTableView)
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: configure hidding and showing the keyboard
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
                self.detailTableView.contentInset = contentInsets
//                self.detailTableView.scrollIndicatorInsets = contentInsets
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        self.detailTableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: delegate funtion from the cell
    
    func isSwitchOn(controller: ReminderCell, switchStatus status: Bool) {
        alertVisible = status
        if alertVisible {
            showAlertCell()
            alertVisible = false
        }else {
            hideAlertCell()
            alertVisible = true
        }
    }
    
    private func showAlertCell() {
        let indexPathAlertRow = NSIndexPath(forRow: 1, inSection: 1)
        detailTableView.beginUpdates()
        detailTableView.insertRowsAtIndexPaths([indexPathAlertRow], withRowAnimation: .Fade)
        detailTableView.endUpdates()
    }
    
    private func hideAlertCell() {
        let indexPathAlertRow = NSIndexPath(forRow: 1, inSection: 1)
        detailTableView.beginUpdates()
        detailTableView.deleteRowsAtIndexPaths([indexPathAlertRow], withRowAnimation: .Fade)
        detailTableView.endUpdates()
    }

}

extension DetailViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            if alertVisible {
                return 2
            }else {
                return 1
            }
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BaseInfoCell.identifier()) as! BaseInfoCell
        let detailCell = tableView.dequeueReusableCellWithIdentifier(DetailInfoCell.identifier()) as! DetailInfoCell
        let reminderCell = tableView.dequeueReusableCellWithIdentifier(ReminderCell.identifier()) as! ReminderCell
        let noteCell = tableView.dequeueReusableCellWithIdentifier(NoteCell.identifier()) as! NoteCell
        let rsvpCell = tableView.dequeueReusableCellWithIdentifier(RSVPCell.identifier()) as! RSVPCell
        let section = indexPath.section
        let row = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        detailCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if section == 0 {
            switch row {
            case 0:
                return configureBaseCellUI(cell, key: "Employer", value: infoSession?.employer)
            case 1:
                return configureBaseCellUI(cell, key: "Date", value: infoSession?.date)
            case 2:
                return configureBaseCellUI(cell, key: "Time", value: infoSession?.time)
            case 3:
                let locationCell = configureBaseCellUI(cell, key: "Location", value: infoSession?.location)
                locationCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                locationCell.selectionStyle = UITableViewCellSelectionStyle.Gray
                return locationCell
            default:
                rsvpCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                return rsvpCell
            }
        }else if section == 1 {
            if row == 0 {
                reminderCell.switchDelegate = self
                return reminderCell
            }else{
                let alertCell = tableView.dequeueReusableCellWithIdentifier(AlertCell.identifier()) as! AlertCell
                return alertCell
            }
        }else if section == 2 {
            switch row {
            case 0:
                let websiteCell = configureBaseCellUI(cell, key: "Website", value: infoSession?.website)
                websiteCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                websiteCell.selectionStyle = UITableViewCellSelectionStyle.Gray
                return websiteCell
            case 1:
                return configureBaseCellUI(cell, key: "Student", value: infoSession?.audience)
            case 2:
                return configerDetailCellUI(detailCell, key: "Programs", value: infoSession?.program)
            default:
                return configerDetailCellUI(detailCell, key: "Description", value: infoSession?.description)
            }
        }else {
            return noteCell
        }
    }
    
    //MARK: configure cell and table functions
    
    private func configureBaseCellUI(cell: BaseInfoCell, key: String, value: String?) -> BaseInfoCell {
        cell.keyLabel.text = key
        cell.valueLabel.text = value
        return cell
    }
    
    private func configerDetailCellUI(cell: DetailInfoCell, key: String, value: String? ) -> DetailInfoCell {
        cell.keyLabel.text = key
        cell.detailLabel.text = value
        return cell
    }
    
}

extension DetailViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 && infoSession?.location != "" {
            let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("UWMaplViewController") as! UWMapViewController
            mapVC.infoSessionLocationString = infoSession?.location
            self.navigationController?.showViewController(mapVC, sender: mapVC)
        }
        
        if indexPath.section == 2 && indexPath.row == 0 && infoSession?.website != "" {
            let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("InfoSessionWebViewController") as! InfoSessionWebsiteViewController
            webVC.websiteName = infoSession?.employer
            webVC.websiteURLString = infoSession?.website
            self.navigationController?.showViewController(webVC, sender: webVC)
        }
    }
}

extension DetailViewController {
    override func screenName() -> String? {
        return "Detail View"
    }
}










