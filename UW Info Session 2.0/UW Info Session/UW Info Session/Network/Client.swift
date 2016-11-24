//
//  Client.swift
//  UW Info Session
//
//  Created by Honghao Zhang on 2015-08-12.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import Alamofire

class Client {
    let infoSessionSourceURL = "http://www.ceca.uwaterloo.ca/students/sessions_details.php?id=%d%@"
    static let sharedInstance = Client()
    let parser = InfoSessionSourceHTMLParser()
    
    func updateFromSourceURLForYear(year: Int, month: Month, completion: (result: Bool) -> Void) {
        let sourceURL = String(format: infoSessionSourceURL, year, month.rawValue)
        log.info("Requesting: \(sourceURL)")
        
        Alamofire.request(.GET, sourceURL).responseString {(_, _, String) -> Void in
            
// allow ios 9 to get the html from website -- http://stackoverflow.com/questions/30731785/how-do-i-load-an-http-url-with-app-transport-security-enabled-in-ios-9
            switch(String){
            case .Success(let string):
                print("Get content successfully!")
                self.parser.parserHTMLString(string)
            case .Failure( _, _):
                print("Get content failed!")
                
            }
            completion(result: Info.shareInstance.finishParsing)
        }
    }
}
