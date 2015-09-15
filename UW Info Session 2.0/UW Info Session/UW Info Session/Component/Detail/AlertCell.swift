//
//  AlertCell.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class AlertCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}


extension AlertCell: TableViewInfo {
    class func identifier() -> String {
        return NSStringFromClass(AlertCell.self)
    }
    
    class func estimatedRowHeight() -> CGFloat {
        return 60
    }
    
    class func registerInTableView(tableView: UITableView) {
        let cellNib = UINib(nibName: "AlertCell", bundle: NSBundle(forClass: DetailInfoCell.self))
        tableView.registerNib(cellNib, forCellReuseIdentifier: AlertCell.identifier())
    }
}