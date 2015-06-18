//
//  CoreDataCRUD
//  EventController.swift
//  Written by Steven R.
//
// @see https://github.com/srmds/CoreData-CRUD-Swift-2.0-example/blob/master/README.md#event-api--persistence-manager
// for more information on the Event API and the Persistence Manager

import UIKit
import Foundation
/**
Endpoint class to be exposed to the view controllers, to communicate
with the retrieval and storage layer.
*/
class EventAPI {
    
    //Manager that does the actual CRUD on the persistence layer
    private let persistenceManager: PersistenceManager
    
    //Utilize Singleton pattern by instanciating EventAPI only once.
    class var sharedInstance: EventAPI {
        struct Singleton {
            static let instance = EventAPI()
        }
        
        return Singleton.instance
    }
    
    init() {
        persistenceManager = PersistenceManager(
            context: (UIApplication.sharedApplication().delegate as!
                AppDelegate).managedObjectContext)
    }
    
    
    // MARK: Create
    
    /**
    Creates a new Managed object and persists to datastore.
    
    :param: - eventDetails Dictionary<String, NSObject> containing
    eventDetails.
    */
    func saveEvent(eventDetails: Dictionary<String, NSObject>) -> Bool {
        return  persistenceManager.saveNewItem(eventDetails)
    }
    
    
    // MARK: Read

    /**
    Retrieves all event items stored in the persistence layer.
    
    :returns: - Array<Event> with found events in datastore
    */
    func getAll() -> Array<Event> {
        return  persistenceManager.retrieveAllItems()
    }
    
    /**
    Retrieve an event found by it's stored id.
    
    :param: - eventId of item to retrieve
    :returns: - event item or nil if event is not found
    */
    func getById(eventId: NSString) -> Array<Event> {
        return persistenceManager.retrieveById(eventId)
    }
    
    /**
    Retrieves all event items stored in the persistence layer
    and sort it by Date.
    
    :returns:  - Array<Event> with found events in datastore based on
    sort descriptor, in this case Date.
    */
    func getSortedByDate() -> Array<Event> {
        return persistenceManager.retrieveItemsSortedByDate()
    }
    
    /**
    Retrieves all event items stored in the persistence layer
    and sort it by Date within a give range.
    
    :returns:  - Array<Event> with found events in datastore based on
    sort descriptor, in this case Date.
    */
    func getSortedByDateInRange() -> Array<Event> {
        
        //Create custom start and end date range, this lets us override default function date parameters
        //for retrieveItemsSortedByDateInDateRange(startDate:currentDate(default), endDate:currentDate + 7 Days (default))
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        
        let componentsStart = NSDateComponents()
        componentsStart.year = 2015
        componentsStart.month = 1
        componentsStart.day = 1

        let componentsEnd = NSDateComponents()
        componentsEnd.year = 2016
        componentsEnd.month = 1
        componentsEnd.day = 1

        let startDate = calendar!.dateFromComponents(componentsStart)!
        let endDate = calendar!.dateFromComponents(componentsEnd)!
        
        return persistenceManager.retrieveItemsSortedByDateInDateRange(startDate, endDate: endDate)
    }
    
    
    // MARK: Update
    
    /**
    Update all events (batch update) attendees list.
    
    Since privacy is always a concern to take into account,
    anonymise the attendees list for every event.
    
    :returns: - bool check whether batch update of event attendees was
    successfull.
    */
    func updateAllEventAttendees() -> Bool {
        return persistenceManager.updateAllEventAttendees()
    }
    
    /**
    Update event item for specific keys.
    
    :returns: bool check whether update of event item key values successfull.
    */
    func updateEvent(eventToUpdate: Event, updateDetails: Dictionary<String,NSObject>) -> Bool {
        return persistenceManager.updateEventItemDetails(eventToUpdate, newEventItemDetails: updateDetails)
    }
    
    
    // MARK: Delete
    
    /**
    Delete all items of Entity: Event, from persistence layer.
    
    :returns: - bool check whether no items are stored anymore
    */
    func deleteAll()  -> Bool {
        return persistenceManager.deleteAllItems()
    }
    
    /**
    Delete item of Entity: Event, from persistence layer.
    
    :returns: - bool check whether deletion succeeded
    */
    func deleteItem(eventItem: Event)  -> Bool {
        return persistenceManager.deleteItem(eventItem)
    }
    
    /**
    Returns a String representation of retrieved event items in passed list.
    
    :param: - List of Event items
    :returns: - String representation of passed in list
    */
    func printList(eventList: Array<Event>) -> String {
        return persistenceManager.printEventList(eventList)
    }
}