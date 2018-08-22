//
//  EventAPI.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import UIKit
import CoreData

/**
    Event API contains the endpoints to Create/Read/Update/Delete Events.
*/
class EventAPI {

    fileprivate let persistenceManager: PersistenceManager!
    fileprivate var mainContextInstance: NSManagedObjectContext!

    fileprivate let idNamespace = EventAttributes.eventId.rawValue
    fileprivate let fbURLNamespace = EventAttributes.fb_url.rawValue
    fileprivate let ticketURLNamespace = EventAttributes.ticket_url.rawValue
    fileprivate let titleNamespace = EventAttributes.title.rawValue
    fileprivate let dateNamespace = EventAttributes.date.rawValue
    fileprivate let cityNamespace = EventAttributes.city.rawValue
    fileprivate let venueNamespace = EventAttributes.venue.rawValue
    fileprivate let countryNamespace = EventAttributes.country.rawValue
    fileprivate let attendeesNamespace = EventAttributes.attendees.rawValue

    //Utilize Singleton pattern by instanciating EventAPI only once.
    class var sharedInstance: EventAPI {
        struct Singleton {
            static let instance = EventAPI()
        }

        return Singleton.instance
    }

    init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }

    /**
     Retrieve an Event
     
     Scenario:
     Given that there there is only a single event in the datastore
     Let say we only created one event in the datastore, then this function will get that single persisted event
     Thus calling this method multiple times will result in getting always the same event.
     
     - Returns: a found Event item, or nil
     */
    func getSingleAndOnlyEvent(eventTitle: String) -> Event? {
        var fetchedResultEvent: Event?
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Event.rawValue)
        
        //Execute Fetch request
        do {
            let fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [Event]
            fetchRequest.fetchLimit = 1
            
            if fetchedResults.count != 0 {
                fetchedResultEvent =  fetchedResults.first
            }
        } catch let fetchError as NSError {
            print("retrieve single event error: \(fetchError.localizedDescription)")
        }
        
        return fetchedResultEvent
    }
    
    // MARK: Create

    /**
        Create a single Event item, and persist it to Datastore via Worker(minion),
        that synchronizes with Main context.
    
        - Parameter eventDetails: <Dictionary<String, AnyObject> A single Event item to be persisted to the Datastore.
        - Returns: Void
    */
    func saveEvent(_ eventDetails: Dictionary<String, AnyObject>) {

        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
        NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance

        //Create new Object of Event entity
        let eventItem = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.Event.rawValue,
            into: minionManagedObjectContextWorker) as! Event

        //Assign field values
        for (key, value) in eventDetails {
            for attribute in EventAttributes.getAll {
                if (key == attribute.rawValue) {
                    eventItem.setValue(value, forKey: key)
                }
            }
        }

        //Save current work on Minion workers
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)

        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()

        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }
    
    /**
     Create a single Event item, and persist it to Datastore via Worker(minion),
     that synchronizes with Main context.
     
     - Parameter eventDetails: <Dictionary<String, AnyObject> A single Event item to be persisted to the Datastore.
     - Returns: Void
     */
    func saveEvent(_ eventTitle: String?) {
        
        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance
        
        //Create new Object of Event entity
        let eventItem = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.Event.rawValue,
                                                            into: minionManagedObjectContextWorker) as! Event
        if eventTitle == nil {
            eventItem.title = "mocked event title"
        } else {
            eventItem.title = eventTitle!
            eventItem.city = "The Hague"
            eventItem.country = "The Netherlands"
            eventItem.fb_url =  URL(string: "http://example.com") as AnyObject
            eventItem.ticket_url = URL(string: "http://example.com") as AnyObject
            eventItem.date = Date()
            eventItem.eventId = "1234"
        }
        
        //Save current work on Minion workers
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        
        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()
        
        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }

    /**
        Create new Events from a given list, and persist it to Datastore via Worker(minion),
        that synchronizes with Main context.
    
        - Parameter eventsList: Array<AnyObject> Contains events to be persisted to the Datastore.
        - Returns: Void
    */
    func saveEventsList(_ eventsList: Array<AnyObject>) {
        DispatchQueue.global().async {

            //Minion Context worker with Private Concurrency type.
            let minionManagedObjectContextWorker: NSManagedObjectContext =
                NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            minionManagedObjectContextWorker.parent = self.mainContextInstance

            //Create eventEntity, process member field values
            for index in 0..<eventsList.count {
                var eventItem: Dictionary<String, NSObject> = eventsList[index] as! Dictionary<String, NSObject>

                //Check that an Event to be stored has a date, title and city.
                if eventItem[self.dateNamespace] as! String != ""
                    && eventItem[self.titleNamespace] as! String != ""
                    && eventItem[self.cityNamespace] as! String != "" {

                    //Create new Object of Event entity
                    let item = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.Event.rawValue,
                                                                   into: minionManagedObjectContextWorker) as! Event

                    //Add member field values
                    item.setValue(DateFormatter.getDateFromString(eventItem[self.dateNamespace] as! String), forKey: self.dateNamespace)
                    item.setValue(eventItem[self.titleNamespace], forKey: self.titleNamespace)
                    item.setValue(eventItem[self.cityNamespace], forKey: self.cityNamespace)
                    item.setValue(eventItem[self.venueNamespace], forKey: self.venueNamespace)
                    item.setValue(eventItem[self.countryNamespace], forKey: self.countryNamespace)
                    item.setValue(eventItem[self.idNamespace], forKey: self.idNamespace)
                    item.setValue(eventItem[self.fbURLNamespace], forKey: self.fbURLNamespace)
                    item.setValue(eventItem[self.ticketURLNamespace], forKey: self.ticketURLNamespace)
                    item.setValue(eventItem[self.attendeesNamespace], forKey: self.attendeesNamespace)

                    //Save current work on Minion workers
                    self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
                }
            }

            //Save and merge changes from Minion workers with Main context
            self.persistenceManager.mergeWithMainContext()

            //Post notification to update datasource of a given Viewcontroller/UITableView
            DispatchQueue.main.async {
                self.postUpdateNotification()
            }
        }
    }

    // MARK: Read

    /**
        Retrieves all event items stored in the persistence layer, default (overridable)
        parameters:
        
        - Parameter sortedByDate: Bool flag to add sort rule: by Date
        - Parameter sortAscending: Bool flag to set rule on sorting: Ascending / Descending date.
    
        - Returns: Array<Event> with found events in datastore
    */
    func getAllEvents(_ sortedByDate: Bool = true, sortAscending: Bool = true) -> Array<Event> {
        var fetchedResults: Array<Event> = Array<Event>()

        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Event.rawValue)

        //Create sort descriptor to sort retrieved Events by Date, ascending
        if sortedByDate {
            let sortDescriptor = NSSortDescriptor(key: dateNamespace,
                ascending: sortAscending)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }

        //Execute Fetch request
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [Event]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Event>()
        }

        return fetchedResults
    }

    /**
        Retrieve an Event, found by it's stored UUID.
    
        - Parameter eventId: UUID of Event item to retrieve
        - Returns: Array of Found Event items, or empty Array
    */
    func getEventById(_ eventId: NSString) -> Array<Event> {
        var fetchedResults: Array<Event> = Array<Event>()

        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Event.rawValue)

        //Add a predicate to filter by eventId
        let findByIdPredicate =
        NSPredicate(format: "\(idNamespace) = %@", eventId)
        fetchRequest.predicate = findByIdPredicate

        //Execute Fetch request
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Event]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Event>()
        }

        return fetchedResults
    }

    /**
        Retrieves all event items stored in the persistence layer
        and sort it by Date within a given range of (default) current date and
        (default)7 days from current date (is overridable, parameters are optional).
        
        - Parameter sortByDate: Bool default and overridable is set to True
        - Parameter sortAscending: Bool default and overridable is set to True
        - Parameter startDate: NSDate default and overridable is set to previous year
        - Parameter endDate: NSDate default and overridable is set to 1 week from current date
        - Returns: Array<Event> with found events in datastore based on
                   sort descriptor, in this case Date an dgiven date range.
    */

    func getEventsInDateRange(_ sortByDate: Bool = true, sortAscending: Bool = true,
        startDate: Date = Date(timeInterval:-189216000, since:Date()),
        endDate: Date = (Calendar.current as NSCalendar)
            .date(
                byAdding: .day, value: 7,
                to: Date(),
                options: NSCalendar.Options(rawValue: 0))!) -> Array<Event> {

        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Event.rawValue)

        //Create sort descriptor to sort retrieved Events by Date, ascending
        let sortDescriptor = NSSortDescriptor(key: EventAttributes.date.rawValue,
            ascending: sortAscending)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors

        //Create predicate to filter by start- / end date
        let findByDateRangePredicate = NSPredicate(format: "(\(dateNamespace) >= %@) AND (\(dateNamespace) <= %@)", startDate as CVarArg, endDate as CVarArg)
        fetchRequest.predicate = findByDateRangePredicate

        //Execute Fetch request
        var fetchedResults = Array<Event>()
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Event]
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDateInDateRange error: \(fetchError.localizedDescription)")
        }

        return fetchedResults
    }

    // MARK: Update

    /**
        Update all events (batch update) attendees list.
        
        Since privacy is always a concern to take into account,
        anonymise the attendees list for every event.
        
        - Returns: Void
    */
    func anonimizeAttendeesList() {
        // Create a fetch request for the entity Person
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Event.rawValue)

        // Execute the fetch request
        var fetchedResults = Array<Event>()
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Event]

            for event in fetchedResults {
                //get count of current attendees list
                let currCount = (event as Event).attendees.count

                //Create an anonymised list of attendees
                //with count of current attendees list
                let anonymisedList = [String](repeating: "Anonymous", count: currCount!)

                //Update current attendees list with anonymised list, shallow copy.
                (event as Event).attendees = anonymisedList as AnyObject
            }
        } catch let updateError as NSError {
            print("updateAllEventAttendees error: \(updateError.localizedDescription)")
        }
    }

    /**
        Update event item for specific keys.
        
        - Parameter eventItemToUpdate: Event the passed event to update it's member fields
        - Parameter newEventItemDetails: Dictionary<String,AnyObject> the details to be updated
        - Returns: Void
    */
    func updateEvent(_ eventItemToUpdate: Event, newEventItemDetails: Dictionary<String, AnyObject>) {

        let minionManagedObjectContextWorker: NSManagedObjectContext =
        NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance

        //Assign field values
        for (key, value) in newEventItemDetails {
            for attribute in EventAttributes.getAll {
                if (key == attribute.rawValue) {
                    eventItemToUpdate.setValue(value, forKey: key)
                }
            }
        }

        //Persist new Event to datastore (via Managed Object Context Layer).
        self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        self.persistenceManager.mergeWithMainContext()

        self.postUpdateNotification()
    }

    // MARK: Delete

    /**
        Delete all Event items from persistence layer.
   
        - Returns: Void
    */
    func deleteAllEvents() {
        let retrievedItems = getAllEvents()

        //Delete all event items from persistance layer
        for item in retrievedItems {
            self.mainContextInstance.delete(item)
        }
        
        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()
        
        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }

    /**
        Delete a single Event item from persistence layer.
        
        - Parameter eventItem: Event to be deleted
        - Returns: Void
    */
    func deleteEvent(_ eventItem: Event) {
        print(eventItem)
        //Delete event item from persistance layer
        self.mainContextInstance.delete(eventItem)
        
        //Save and merge changes from Minion workers with Main context
        self.persistenceManager.mergeWithMainContext()
        
        //Post notification to update datasource of a given Viewcontroller/UITableView
        self.postUpdateNotification()
    }

    /**
        Post update notification to let the registered listeners refresh it's datasource.
    
        - Returns: Void
    */
    fileprivate func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateEventTableData"), object: nil)
    }

}
