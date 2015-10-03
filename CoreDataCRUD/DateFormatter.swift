//
//  DateFormatter.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 01/10/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation

/**
    DateFormatter Utility class
*/
class DateFormatter {
    
    /**
        Get a NSDate formatted object from a given String.
    
        - Note: the dateFormat is an optional parameter, with default value: dd-MM-yyyy
        - Parameter dateString: The Date String to parse.
        - Parameter dateFormat: The output format of the NSDate object.
        - Returns: NSDate formatted Date object
    */
    class func getDateFromString(dateString:String, dateFormat:String = "dd-MM-yyyy") -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.dateFromString(dateString)!
    }
    
    /**
        Get a formatted String from a given NSDate object
        
        - Note: the dateFormat is an optional parameter, with default value: dd-MM-yyyy
        - Parameter date: The Date object to parse
        - Parameter dateFormat: The output format of the output String
        - Returns: String formatted output date String
    */
    class func getStringFromDate(date:NSDate, dateFormat:String = "dd-MM-yyyy") -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.stringFromDate(date)
    }

}