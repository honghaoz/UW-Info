//
//  ReminderCell.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-03.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension ReminderCell: TableViewInfo {
    class func identifier() -> String {
        return NSStringFromClass(ReminderCell.self)
    }
    
    class func estimatedRowHeight() -> CGFloat {
        return 60
    }
    
    class func registerInTableView(tableView: UITableView) {
        let cellnib = UINib(nibName: "ReminderCell", bundle: NSBundle(forClass: ReminderCell.self))
        tableView.registerNib(cellnib, forCellReuseIdentifier: ReminderCell.identifier())
    }
}
