//
//  StringExtension.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 30/09/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation

extension String {
    //Custom extension method to append Strings
    mutating func append(str: String) {
        self = self + str
    }
    
    //Custom extension method to URL encode a String
    mutating func URLEncodedString() -> String? {
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
        return escapedString
    }
}