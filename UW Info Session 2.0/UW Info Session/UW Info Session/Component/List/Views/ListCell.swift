//
//  ListCell.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-11.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
	
    @IBOutlet weak var employerName: UILabel!
    @IBOutlet weak var date_time: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellForInfoSession(InfoSession: InfoSessionUnit) {
        employerName.text = InfoSession.employer
        date_time.text = "\(InfoSession.date) \(InfoSession.time)"
        locationLabel.text = "\(InfoSession.location)"
    }
}

extension ListCell: TableViewInfo {
	class func identifier() -> String {
		return NSStringFromClass(ListCell.self)
	}
    
    class func estimatedRowHeight() -> CGFloat {
        return 100
    }
    
    class func registerInTableView(tableView: UITableView) {
        let nib = UINib(nibName: "ListCell", bundle: NSBundle(forClass: ListCell.self))
        tableView.registerNib(nib, forCellReuseIdentifier: ListCell.identifier())
    }
}
