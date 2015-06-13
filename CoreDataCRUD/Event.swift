//
//  Event.swift
//  CoreDataCRUD
//  Written by Steven R.
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
