//
//  BaseInfoCell.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-08-27.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class BaseInfoCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension BaseInfoCell: TableViewInfo {
    class func identifier() -> String {
        return NSStringFromClass(BaseInfoCell.self)
    }
    
    class func estimatedRowHeight() -> CGFloat {
        return 60
    }
    
    class func registerInTableView(tableView: UITableView) {
        let cellNib = UINib(nibName: "BaseInfoCell", bundle: NSBundle(forClass: BaseInfoCell.self))
        tableView.registerNib(cellNib, forCellReuseIdentifier: BaseInfoCell.identifier())
    }
}
