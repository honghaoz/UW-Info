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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupTableView() {
        BaseInfoCell.registerInTableView(detailTableView)
        DetailInfoCell.registerInTableView(detailTableView)
        ReminderCell.registerInTableView(detailTableView)
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
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
            default:
                return configureBaseCellUI(cell, key: "Location", value: infoSession?.location)
                
            }
        }else if section == 1 {
            return reminderCell
        }else {
            switch row {
            case 0:
                return configureBaseCellUI(cell, key: "Website", value: infoSession?.website)
            case 1:
                return configureBaseCellUI(cell, key: "Student", value: infoSession?.audience)
            case 2:
                return configerDetailCellUI(detailCell, key: "Programs", value: infoSession?.program)
            default:
                return configerDetailCellUI(detailCell, key: "Description", value: infoSession?.description)
            }
        }
    }
    
    
    private func configureBaseCellUI(cell: BaseInfoCell, key: String, value: String?) -> BaseInfoCell {
        cell.keyLabel.text = key
        cell.valueLabel.text = value
        return cell
    }
    
    private func configerDetailCellUI(cell: DetailInfoCell, key: String, value: String?) -> DetailInfoCell {
        cell.keyLabel.text = key
        cell.detailLabel.text = value
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension DetailViewController: Analytics {
    override func screenName() -> String? {
        return "Detail View"
    }
}










