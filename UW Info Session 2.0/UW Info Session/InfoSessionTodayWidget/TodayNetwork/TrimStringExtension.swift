//
//  TrimStringExtension.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-13.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import Foundation

extension String {
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
    
    :returns: Stripped string
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
    
    :returns: Stripped string
    */
    func trimmed () -> String {
        return trimmedLeft().trimmedRight()
    }
}
