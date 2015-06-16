//
//  Event.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import Foundation
import CoreData

@objc(Event)

class Event: NSManagedObject {
    
    @NSManaged var attendees: AnyObject
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var venue: String
    @NSManaged var eventId: String
    @NSManaged var date: NSDate
    @NSManaged var fb_url: AnyObject
    @NSManaged var ticket_url: AnyObject
    @NSManaged var title: String

}
