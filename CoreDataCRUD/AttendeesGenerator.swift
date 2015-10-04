//
//  AttendeesGenerator.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 01/10/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation

class AttendeesGenerator {

    /**
    Generate (pseudo) random attendeeslist of (pseudo) random size and (pseudo) random attendees.
    
    For true randomness see:
    - Link: https://en.wikipedia.org/wiki/Hardware_random_number_generator
    
    - Returns: Array<String> A (pseudo) random generated attendeeslist
    */
    class func getSemiRandomGeneratedAttendeesList() -> Array<String> {
        let optionalAttendees = [
            "Yoda",
            "HAL 9000",
            "Gizmo",
            "Optimus Prime",
            "Marvin the Paranoid Android",
            "ET",
            "Bender",
            "Narcissus",
            "Frodo",
            "Esscher",
            "Lothar Collatz",
            "Foo",
            "Bar",
            "Tweety"
        ]
        
        var attendeesList = [String]()
        let listSize:Int =  Int(arc4random_uniform(UInt32(truncatingBitPattern: optionalAttendees.count)))
        
        for _ in 0...listSize {
            let itemIndex:Int =  Int(arc4random_uniform(UInt32(truncatingBitPattern: listSize)))
            let item:String = optionalAttendees[itemIndex]
            if !attendeesList.contains(item) {
                attendeesList.append(item)
            }
        }
        
        return attendeesList
    }

}