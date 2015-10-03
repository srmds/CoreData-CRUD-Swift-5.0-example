//
//  DateFormatter.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 01/10/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation

class DateFormatter {
    
    class func getDateFromString(dateString:String, dateFormat:String = "dd-MM-yyyy") -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.dateFromString(dateString)!
    }
    
    class func getStringFromDate(date:NSDate, dateFormat:String = "dd-MM-yyyy") -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.stringFromDate(date)
    }

}