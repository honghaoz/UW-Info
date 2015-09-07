//
//  DescriptionInfoCell.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-05.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class DescriptionInfoCell: UITableViewCell {
    
    var infoDescription :String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension DescriptionInfoCell: UITextViewDelegate {
    
}


extension DescriptionInfoCell: TableViewInfo {
    class func identifier() -> String {
        return NSStringFromClass(DescriptionInfoCell.self)
    }
    
    class func estimatedRowHeight() -> CGFloat {
        return 150
    }
    
    class func registerInTableView(tableView: UITableView) {
        let cellnib = UINib(nibName: "DescriptionInfoCell", bundle: NSBundle(forClass: DescriptionInfoCell.self))
        tableView.registerNib(cellnib, forCellReuseIdentifier: DescriptionInfoCell.identifier())
    }
}
