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
    Creates test data by creating new Event objects and assigning
    property values and calling the managed object layer to persist
    to the datastore.
    */
    func createAndPersistTestData() -> Bool {
        
        //Create some Date offsets to be able to sort on
        let today = NSDate()
        let tomorrow: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: 1,
            toDate: today,
            options: NSCalendarOptions(rawValue: 0))!
        
        let relativetime: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: 22,
            toDate: today,
            options: NSCalendarOptions(rawValue: 0))!
        
        //Create a Dictionary, key - values with event details
        let eventDetailsItem1 = [
            "\(Constants.EventAttributes.eventId.rawValue)": NSUUID().UUIDString,
            "\(Constants.EventAttributes.title.rawValue)": "Galaxy gathering of the coolest",
            "\(Constants.EventAttributes.date.rawValue)":  today,
            "\(Constants.EventAttributes.venue.rawValue)": "The Milkyway",
            "\(Constants.EventAttributes.city.rawValue)": "Nebula Town",
            "\(Constants.EventAttributes.country.rawValue)" : "Blackhole",
            "\(Constants.EventAttributes.attendees.rawValue)":["Yoda",
                "HAL 9000",
                "Gizmo",
                "Optimus Prime",
                "Marvin the Paranoid Android",
                "ET",
                "Bender"],
            "\(Constants.EventAttributes.fb_url.rawValue)": "https://www.facebook.com/events/111789708883460/",
            "\(Constants.EventAttributes.ticket_url.rawValue)": "http://en.wikipedia.org/wiki/Pi"
        ]
        
        let eventDetailsItem2 = [
            "\(Constants.EventAttributes.eventId.rawValue)": NSUUID().UUIDString,
            "\(Constants.EventAttributes.title.rawValue)": "King Shiloh Soundsystem",
            "\(Constants.EventAttributes.date.rawValue)":  tomorrow,
            "\(Constants.EventAttributes.venue.rawValue)": "Tivoli Vredenburg",
            "\(Constants.EventAttributes.city.rawValue)" :"Utrecht",
            "\(Constants.EventAttributes.country.rawValue)": "Netherlands",
            "\(Constants.EventAttributes.attendees.rawValue)":["Foo","Bar","Tweety"],
            "\(Constants.EventAttributes.fb_url.rawValue)": "https://www.facebook.com/events/1558804814366111/",
            "\(Constants.EventAttributes.ticket_url.rawValue)": "https://www.facebook.com/LooneyTunes"
        ]
        
        let eventDetailsItem3 = [
            "\(Constants.EventAttributes.eventId.rawValue)": NSUUID().UUIDString,
            "\(Constants.EventAttributes.title.rawValue)": "Festifest 2015",
            "\(Constants.EventAttributes.date.rawValue)":  relativetime,
            "\(Constants.EventAttributes.venue.rawValue)": "NDSM-werf",
            "\(Constants.EventAttributes.city.rawValue)" :"Amsterdam",
            "\(Constants.EventAttributes.country.rawValue)": "Netherlands",
            "\(Constants.EventAttributes.attendees.rawValue)":["Narcissus","Frodo","Esscher","Lothar Collatz"],
            "\(Constants.EventAttributes.fb_url.rawValue)": "https://www.facebook.com/events/340083322848962/",
            "\(Constants.EventAttributes.ticket_url.rawValue)": "https://shop.ticketscript.com/channel/web2/start-order/rid/BL84CC4C/language/en"
        ]
        
        //Create and store eventItems
        var success:Bool
        
        success = saveEvent(eventDetailsItem1)
        print("Test object 1 creation succeeded: \(success)\n\n")
        
        success = saveEvent(eventDetailsItem2)
        print("Test object 2 creation succeeded: \(success)\n\n")
        
        success = saveEvent(eventDetailsItem3)
        print("Test object 3 creation succeeded: \(success)\n\n")
        
        return success
    }
    
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