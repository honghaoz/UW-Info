//
//  DetailViewController.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-11.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {
    
    var shouldHide: Bool = true
    
    var infoSession: InfoSessionUnit?
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
//        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupTableView() {
        BaseInfoCell.registerInTableView(detailTableView)
        DetailInfoCell.registerInTableView(detailTableView)
        ReminderCell.registerInTableView(detailTableView)
        DescriptionInfoCell.registerInTableView(detailTableView)
        NoteCell.registerInTableView(detailTableView)
        RSVPCell.registerInTableView(detailTableView)
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            return 1
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
        let descriptionCell = tableView.dequeueReusableCellWithIdentifier(DescriptionInfoCell.identifier()) as! DescriptionInfoCell
        let noteCell = tableView.dequeueReusableCellWithIdentifier(NoteCell.identifier()) as! NoteCell
        let rsvpCell = tableView.dequeueReusableCellWithIdentifier(RSVPCell.identifier()) as! RSVPCell
        var section = indexPath.section
        var row = indexPath.row
        
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
                return locationCell
            default:
                rsvpCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                return rsvpCell
            }
        }else if section == 1 {
            return reminderCell
        }else if section == 2 {
            switch row {
            case 0:
                let websiteCell = configureBaseCellUI(cell, key: "Website", value: infoSession?.website)
                websiteCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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
        if indexPath.section == 0 && indexPath.row == 3 {
            let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("UWMapNavigationController") as! UINavigationController
            self.showViewController(mapVC, sender: self)
        }
    }
    
}

extension DetailViewController: Analytics {
    override func screenName() -> String? {
        return "Detail View"
    }
}










