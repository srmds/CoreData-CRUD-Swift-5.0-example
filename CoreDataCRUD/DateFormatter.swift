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
    class func getDateFromString(_ dateString:String, dateFormat:String = "dd-MM-yyyy") -> Date {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: dateString)!
    }
    
    /**
        Get a formatted String from a given NSDate object
        
        - Note: the dateFormat is an optional parameter, with default value: dd-MM-yyyy
        - Parameter date: The Date object to parse
        - Parameter dateFormat: The output format of the output String
        - Returns: String formatted output date String
    */
    class func getStringFromDate(_ date:Date, dateFormat:String = "dd-MM-yyyy") -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: date)
    }

}
