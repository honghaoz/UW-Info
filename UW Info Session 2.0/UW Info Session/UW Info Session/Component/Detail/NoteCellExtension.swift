//
//  NoteCellExtension.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-06.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
}

