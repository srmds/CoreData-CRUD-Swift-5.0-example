//
//  Event.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 12/06/15.
//  Copyright (c) 2015 io pandacode. All rights reserved.
//

import Foundation
import CoreData

@objc(Event)

class Event: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var date: NSDate
    @NSManaged var venue: String
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var attendees: AnyObject
    @NSManaged var fb_url: AnyObject
    @NSManaged var ticket_url: AnyObject
    @NSManaged var eventId: String

}
