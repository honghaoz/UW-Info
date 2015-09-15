//
//  TodayInfoSession.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-13.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation


struct InfoSessionUnit {
    var employer: String = ""
    var date: String = ""
    var time: String = ""
    var location: String = ""
}

class TodayInfoSession {
    
    static let shareInstance = TodayInfoSession()
    
    var InfoSessions = [InfoSessionUnit]()
    
    var finishParsing = false
}