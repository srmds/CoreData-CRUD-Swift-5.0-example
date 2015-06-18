//
//  CoreDataCRUD
//  EventController.swift
//  Written by Steven R.
//
// @see https://github.com/srmds/CoreData-CRUD-Swift-2.0-example/blob/master/README.md#event-api--persistence-manager
// for more information on the Event API and the Persistence Manager

import UIKit
import CoreData

/**
A manager that allows CRUD operations on the persistence store
with an Event entity.
*/
class PersistenceManager {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: Create
    
    /**
    Creates a new Managed object and persists to datastore.
    
    :param: eventDetails Dictionary<String, NSObject> containing
    eventDetails.
    */
    func saveNewItem(eventDetails: Dictionary<String, NSObject>) -> Bool {
        
        //Reference to Event entity
        let entity = NSEntityDescription.entityForName(Constants.CoreDataEntities.EventEntiy,
            inManagedObjectContext:context)
        
        //Create new Object of Event entity
        let eventItem = Event(entity: entity!,
            insertIntoManagedObjectContext: context)
        
        //Assign field values
        for (key, value) in eventDetails {
            for attribute in Constants.EventAttributes.getAll {
                if (key == attribute.rawValue) {
                    eventItem.setValue(value, forKey: key)
                }
            }
        }
        
        //Persist new Event to datastore (via Managed Object Context Layer).
        var success:Bool
        do {
            try context.save()
            success = true
        } catch let saveError as NSError {
            print("saveNewItem error: \(saveError.localizedDescription)")
            success = false
        }
        
        return success
    }
    
    // MARK: Read
    
    /**
    Retrieves all event items stored in the persistence layer.
    
    :returns:  Array<Event> with found events in datastore
    */
    func retrieveAllItems() -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntities.EventEntiy)
        
        //Execute Fetch request
        var fetchedResults:Array<Event> = Array<Event>()
        do {
            fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Event]
            
        } catch let fetchError as NSError {
            print("retrieveAllItems error: \(fetchError.localizedDescription)")
        }
        
        return fetchedResults
    }
    
    /**
    Retrieve an event found by it's stored id.
    
    :param: eventId of item to retrieve
    :returns: event item or nil if event is not found
    */
    func retrieveById(eventId: NSString) -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntities.EventEntiy)
        fetchRequest.returnsObjectsAsFaults = false;
        
        //Add a predicate to filter by eventId
        let findByIdPredicate =
        NSPredicate(format: "\(Constants.EventAttributes.eventId.rawValue) = %@", eventId)
        fetchRequest.predicate = findByIdPredicate
        
        //Execute Fetch request
        var fetchedResults: Array<Event>
        do {
            fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Event]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Event>()
        }
        
        return fetchedResults
    }
    
    /**
    Retrieves all event items stored in the persistence layer
    and sort it by Date.
    
    :returns: Array<Event> with found events in datastore based on
    sort descriptor, in this case Date.
    */
    func retrieveItemsSortedByDate() -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntities.EventEntiy)
        
        //Create sort descriptor to sort retrieved Events by Date, ascending
        let sortDescriptor = NSSortDescriptor(key: Constants.EventAttributes.date.rawValue,
            ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        //Execute Fetch request
        var fetchedResults = Array<Event>()
        do {
            fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Event]
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDate error: \(fetchError.localizedDescription)")
        }
        
        return fetchedResults
    }

    /**
    Retrieves all event items stored in the persistence layer
    and sort it by Date within a given range of (default) current date and 
    (default)7 days from current date (is overridable, parameters are optional).
    
    :returns: Array<Event> with found events in datastore based on
    sort descriptor, in this case Date an dgiven date range.
    */

    func retrieveItemsSortedByDateInDateRange(startDate: NSDate = NSDate(),
        endDate: NSDate = NSCalendar.currentCalendar()
            .dateByAddingUnit(
                .Day,value: 7,
                toDate: NSDate(),
                options: NSCalendarOptions(rawValue: 0))!) -> Array<Event> {
                                                    
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntities.EventEntiy)

        //Create sort descriptor to sort retrieved Events by Date, ascending
        let sortDescriptor = NSSortDescriptor(key: Constants.EventAttributes.date.rawValue,
            ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors

        let findByDateRangePredicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        fetchRequest.predicate = findByDateRangePredicate

        //Execute Fetch request
        var fetchedResults = Array<Event>()
        do {
            fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Event]
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDateInDateRange error: \(fetchError.localizedDescription)")
        }
        
        return fetchedResults
    }
    
    /**
    Get a date as formatted String
    */
    private func getFormattedDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let DateInFormat = dateFormatter.stringFromDate(date)
        
        return DateInFormat
    }
    
    // MARK: Update
    
    /**
    Update all events (batch update) attendees list.
    
    Since privacy is always a concern to take into account,
    anonymise the attendees list for every event.
    
    :returns: bool check whether batch update of event attendees was
    successfull.
    */
    func updateAllEventAttendees() -> Bool {
        
        // Create a fetch request for the entity Person
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntities.EventEntiy)
        
        // Execute the fetch request
        var fetchedResults = Array<Event>()
        var success:Bool
        do {
            fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Event]
            
            for event in fetchedResults {
                //get count of current attendees list
                let currCount = (event as Event).attendees.count
                
                //Create an anonymised list of attendees
                //with count of current attendees list
                let anonymisedList = [String](count: currCount, repeatedValue: "anon")
                
                //Update current attendees list with anonymised list, shallow copy.
                (event as Event).attendees = anonymisedList
            }
            success = true
        } catch let updateError as NSError {
            print("updateAllEventAttendees error: \(updateError.localizedDescription)")
            success = false
        }
        
        return success
    }
    
    /**
    Update event item for specific keys.
    
    :returns: bool check whether update of event item key values successfull.
    */
    func updateEventItemDetails(eventItemToUpdate: Event, newEventItemDetails: Dictionary<String, NSObject>) -> Bool {
        
        //Assign field values
        for (key, value) in newEventItemDetails {
            for attribute in Constants.EventAttributes.getAll {
                if (key == attribute.rawValue) {
                    eventItemToUpdate.setValue(value, forKey: key)
                }
            }
        }
        
        //Persist new Event to datastore (via Managed Object Context Layer).
        var success:Bool
        do {
            try context.save()
            success = true
        } catch let updateError as NSError {
            print("updateEventItemDetails error: \(updateError.localizedDescription)")
            success = false
        }
        
        return success
    }
    
    // MARK: Delete
    
    /**
    Delete all items of Entity: Event, from persistence layer.
    
    :returns: bool check whether no items are stored anymore
    */
    func deleteAllItems()  -> Bool {
        
        //Persist deletion
        var success:Bool
        do {
            let retrievedItems = retrieveAllItems()
            
            //Delete all event items from persistance layer
            for item in retrievedItems {
                context.deleteObject(item)
            }
            
            //Persist deletion to datastore
            try context.save()
            success = true
        } catch let deleteError as NSError {
            print("retrieveItemsSortedByDate error: \(deleteError.localizedDescription)")
            success = false
        }
        
        return success
    }
    
    /**
    Delete all items of Entity: Event, from persistence layer.
    
    :returns: bool check whether no items are stored anymore
    */
    func deleteItem(eventItem: Event)  -> Bool {
        
        //Persist deletion
        var success:Bool
        do {
            //Delete event item from persistance layer
            context.deleteObject(eventItem)
            
            //Persist deletion to datastore
            try context.save()
            success = true
        } catch let deleteError as NSError {
            print("retrieveItemsSortedByDate error: \(deleteError.localizedDescription)")
            success = false
        }
        
        return success
    }
    
}