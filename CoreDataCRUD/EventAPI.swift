//
//  CoreDataCRUD
//  EventController.swift
//  Written by Steven R.
//

import UIKit

/**
    Endpoint class to be exposed to the view controllers, to communicate 
    with the retrieval and storage layer.
*/
class EventAPI {
    
    //Name of the Event entity
    private let eventNamespace = "Event"
    
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
    func createAndPersistTestData() {
        
        //Create some Date offsets to be able to sort on
        let today = NSDate()
        let tomorrow: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: 1,
            toDate: today,
            options: NSCalendarOptions(rawValue: 0))!
        
        //Create a Dictionary, key - values with event details
        let eventDetailsItem1 = [
            "eventId": NSUUID().UUIDString,
            "title": "Galaxy gathering of the coolest",
            "date":  today,
            "venue": "The Milkyway",
            "city": "Nebula Town",
            "country" : "Blackhole",
            "attendees":["Yoda",
                "HAL 9000",
                "Gizmo",
                "Optimus Prime",
                "Marvin the Paranoid Android",
                "ET",
                "Bender"],
            "fb_url": "https://www.facebook.com/events/111789708883460/",
            "ticket_url": "http://en.wikipedia.org/wiki/Pi"
        ]
        
        let eventDetailsItem2 = [
            "eventId": NSUUID().UUIDString,
            "title": "King Shiloh Soundsystem",
            "date":  tomorrow,
            //should properly be seperated in: venue, city and country keys
            "venue": "Tivoli Vredenburg",
            "city" :"Utrecht",
            "country": "Netherlands",
            "attendees":["Foo","Bar","Tweety"],
            "fb_url": "https://www.facebook.com/events/1558804814366111/",
            "ticket_url": "https://www.facebook.com/LooneyTunes"
        ]
        
        //Create and store eventItems
        var success:Bool
        
        success = saveEvent(eventDetailsItem1)
        print("Test object 1 creation succeeded: \(success)\n\n")
        
        success = saveEvent(eventDetailsItem2)
        print("Test object 2 creation succeeded: \(success)\n\n")
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
    
    
    // MARK: Delete
    
    /**
        Delete all items of Entity: Event, from persistence layer.
    
        :returns: - bool check whether no items are stored anymore
    */
    func deleteAll()  -> Bool {
        return persistenceManager.deleteAllItems()
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