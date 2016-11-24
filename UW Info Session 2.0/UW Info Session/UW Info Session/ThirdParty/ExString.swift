//
//  ExString.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-18.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int { return self.characters.count }
    /**
    Finds any match in self for pattern.
    
    - parameter pattern: Pattern to match
    - parameter ignoreCase: true for case insensitive matching
    - returns: Matches found (as [NSTextCheckingResult])
    */
    func matches (pattern: String, ignoreCase: Bool = false) -> [NSTextCheckingResult]? {
        
        if let regex = ExSwift.regex(pattern, ignoreCase: ignoreCase) {
            //  Using map to prevent a possible bug in the compiler
            return regex.matchesInString(self, options: [], range: NSMakeRange(0, length)).map { $0 }
        }
        
        return nil
    }
    
    /**
    Check is string with this pattern included in string
    
    - parameter pattern: Pattern to match
    - parameter ignoreCase: true for case insensitive matching
    - returns: true if contains match, otherwise false
    */
    func containsMatch (pattern: String, ignoreCase: Bool = false) -> Bool? {
        if let regex = ExSwift.regex(pattern, ignoreCase: ignoreCase) {
            let range = NSMakeRange(0, self.characters.count)
            return regex.firstMatchInString(self, options: [], range: range) != nil
        }
        
        return nil
    }

    /**
    Strips the specified characters from the beginning of self.
    
    - returns: Stripped string
    */
    func trimmedLeft (characterSet set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet) {
            return self[range.startIndex..<endIndex]
        }
        
        return ""
    }
    
    @available(*, unavailable, message="use 'trimmedLeft' instead") func ltrimmed (set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        return trimmedLeft(characterSet: set)
    }
    
    /**
    Strips the specified characters from the end of self.
    
    - returns: Stripped string
    */
    func trimmedRight (characterSet set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet, options: NSStringCompareOptions.BackwardsSearch) {
            return self[startIndex..<range.endIndex]
        }
        
        return ""
    }
    
    @available(*, unavailable, message="use 'trimmedRight' instead") func rtrimmed (set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        return trimmedRight(characterSet: set)
    }
    
    /**
    Strips whitespaces from both the beginning and the end of self.
    
    - returns: Stripped string
    */
    func trimmed () -> String {
        return trimmedLeft().trimmedRight()
    }
    
    
    /**
    Replace all pattern matches with another string
    
    - parameter pattern: Pattern to match
    - parameter replacementString: string to replace matches
    - parameter ignoreCase: true for case insensitive matching
    - returns: true if contains match, otherwise false
    */
    func replaceMatches (pattern: String, withString replacementString: String, ignoreCase: Bool = false) -> String? {
        if let regex = ExSwift.regex(pattern, ignoreCase: ignoreCase) {
            let range = NSMakeRange(0, self.characters.count)
            return regex.stringByReplacingMatchesInString(self, options: [], range: range, withTemplate: replacementString)
        }
        
        return nil
    }

    

}