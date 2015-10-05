//
//  RSVPCell.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-07.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class RSVPCell: UITableViewCell {

    @IBOutlet weak var RSVPLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        RSVPLabel.textColor = UIColor.lightGrayColor()
        RSVPLabel.text = "Not Available to RSVP"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension RSVPCell: TableViewInfo {
    class func identifier() -> String {
        return NSStringFromClass(RSVPCell.self)
    }
    
    class func estimatedRowHeight() -> CGFloat {
        return 44
    }
    
    class func registerInTableView(tableView: UITableView) {
        let cellnib = UINib(nibName: "RSVPCell", bundle: NSBundle(forClass: RSVPCell.self))
        tableView.registerNib(cellnib, forCellReuseIdentifier: RSVPCell.identifier())
    }
}
