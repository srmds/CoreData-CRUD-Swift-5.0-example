//
//  AttendeesGenerator.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
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
        //let value = Int64(arc4random()) % Int64(optionalAttendees.count) + Int64(1)
        let listSize: Int =  3//Int(arc4random_uniform(UInt32(extendingOrTruncating: optionalAttendees.count)))

        for _ in 0...listSize {
            let itemIndex: Int =  0//Int(arc4random_uniform(UInt32(extendingOrTruncating: listSize)))
            let item: String = optionalAttendees[itemIndex]
            if !attendeesList.contains(item) {
                attendeesList.append(item)
            }
        }

        return attendeesList
    }

}
