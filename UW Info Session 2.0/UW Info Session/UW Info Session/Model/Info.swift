//
//  Info.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-08-25.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

struct InfoSessionUnit {
    var employer: String = ""
    var date: String = ""
    var time: String = ""
    var location: String = ""
    var website: String = ""
    var audience: String = ""
    var program: String = ""
    var description: String = ""
}


class Info {    
    
    static let shareInstance = Info()
    
    var InfoSessions = [InfoSessionUnit]()
    
    var finishParsing = false
    
}