//
//  TodayClient.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-13.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import Alamofire

enum Month: String {
    case Jan = "Jan"
    case Feb = "Feb"
    case Mar = "Mar"
    case Apr = "Apr"
    case May = "May"
    case Jun = "Jun"
    case Jul = "Jul"
    case Aug = "Aug"
    case Sep = "Sep"
    case Oct = "Oct"
    case Nov = "Nov"
    case Dec = "Dec"
}


class TodayClient {
    let infoSessionSourceURL = "http://www.ceca.uwaterloo.ca/students/sessions_details.php?id=%d%@"
    static let sharedInstance = TodayClient()
    let parser = TodayInfoSessionHTMLParser()
    
    func updateFromSourceURLForToday(year: Int, month: Month, completion: (result: Bool) -> Void) {
        let sourceURL = String(format: infoSessionSourceURL, year, month.rawValue)
        print("Requesting: \(sourceURL)")
        
        Alamofire.request(.GET, sourceURL).responseString {[unowned self] (request, response, String) -> Void in

            switch(String){
            case .Success(let string):
                print("Get content successfully!")
                self.parser.parserHTMLString(string)
            case .Failure( _, _):
                print("Get content failed!")
                
            }
            completion(result: TodayInfoSession.shareInstance.finishParsing)
        }
    }
}
