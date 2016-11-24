//
//  TodayInfoSessionHTMLParser.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-13.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import Ji
import SwiftyJSON

struct TodayInfoSessionHTMLParser {
    let kEmployer = "Employer"
    let kDate = "Date"
    let kTime = "Time"
    let kLocation = "Location"
    
    var result = [String: AnyObject]()
    
    func parserHTMLString(string: String) {

        let doc: Ji! = Ji(htmlString: string)
        if doc == nil {
            print("Setup Ji doc failed")
        }
        
        let nodes = doc.xPath("//*[@id='tableform']")
        if let tableNode = nodes?.first where tableNode.name == "table" {
            // Divide trs into different sessions
            // Each session is a list of tr Ji node
            var trSessionGroups = [[JiNode]]()
            var trSessionGroup: [JiNode]?
            for tr in tableNode {
                if let tdContent = tr.firstChildWithName("td")?.content {
                    if tdContent.hasPrefix("\(kEmployer):") {
                        if let trSessionGroup = trSessionGroup { trSessionGroups.append(trSessionGroup) }
                        trSessionGroup = [tr]
                        continue
                    }
                    trSessionGroup!.append(tr)
                }
            }
            
            // Process each session group to a dictionary
            _ = JSON(trSessionGroups.map { self.processTrSessionGroupToDict($0) })
            //            log.debug(json)
            
            TodayInfoSession.shareInstance.finishParsing = true
        }
    }
    
    private func processTrSessionGroupToDict(trSession: [JiNode]) -> [[String: String]] {
        var resultUnit = [[String: String]]()
        var unit = InfoSessionUnit()
        
        let date = NSDate()
        let infoSessionDateFormat = NSDateFormatter()
        infoSessionDateFormat.dateFormat = "MMMM d, yyyy"
        let todayDate = infoSessionDateFormat.stringFromDate(date)
        
        for (_, tr) in trSession.enumerate() {
            if let firstString = tr.firstChild?.content?.trimmed() where firstString.hasPrefix("\(kEmployer):") {
                let secondString = tr.firstChild?.nextSibling?.content?.trimmed()
                resultUnit.append([kEmployer: secondString ?? "null"])
                unit.employer = secondString!
            } else if let firstString = tr.firstChild?.content?.trimmed() where firstString.hasPrefix("\(kDate):") {
                let secondString = tr.firstChild?.nextSibling?.content?.trimmed()
                resultUnit.append([kDate: secondString ?? "null"])
                unit.date = secondString!
            } else if let firstString = tr.firstChild?.content?.trimmed() where firstString.hasPrefix("\(kTime):") {
                let secondString = tr.firstChild?.nextSibling?.content?.trimmed()
                resultUnit.append([kTime: secondString ?? "null"])
                unit.time = secondString!
            } else if let firstString = tr.firstChild?.content?.trimmed() where firstString.hasPrefix("\(kLocation):") {
                let secondString = tr.firstChild?.nextSibling?.content?.trimmed()
                resultUnit.append([kLocation: secondString ?? "null"])
                unit.location = secondString!
            }
        }
        
        if unit.employer != "" && unit.location != "" && unit.date == todayDate {
            TodayInfoSession.shareInstance.InfoSessions.append(unit)
        }
        
        return resultUnit
    }

}