//
//  ViewConnector.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-08-27.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation


protocol ViewConnector {
    func switchViewWithIdentifier(view: String, sender: Int)
}