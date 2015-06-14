//
//  CoreDataCRUD
//  EventController.swift
//  Written by Steven R.
//
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
        let entity = NSEntityDescription.entityForName(Constants.eventNamespace,
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
        
        //Persist new Event to database (via Managed Object Context Layer.
        do {
            try context.save()
            return true
        } catch let fetchError as NSError {
            print("saveNewItem error: \(fetchError.localizedDescription)")
            return false
        }
    }
    
    // MARK: Read
    
    /**
        Retrieves all event items stored in the persistence layer.
    
        :returns:  Array<Event> with found events in datastore
    */
    func retrieveAllItems() -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: Constants.eventNamespace)
        
        //Execute Fetch request returns result as array.
        var fetchedResults:Array<Event> = Array<Event>()
        do {
            fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Event]
            return fetchedResults
        } catch let fetchError as NSError {
            print("retrieveAllItems error: \(fetchError.localizedDescription)")
            return fetchedResults
        }
    }
    
    /**
        Retrieve an event found by it's stored id.
    
        :param: eventId of item to retrieve
        :returns: event item or nil if event is not found
    */
    func retrieveById(eventId: NSString) -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: Constants.eventNamespace)
        fetchRequest.returnsObjectsAsFaults = false;
        
        //Add a predicate to filter by eventId
        let findByIdPredicate =
            NSPredicate(format: "\(Constants.EventAttributes.eventId.rawValue) = %@", eventId)
        fetchRequest.predicate = findByIdPredicate
        
        //Execute Fetch request returns result as array or
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
        let fetchRequest = NSFetchRequest(entityName: Constants.eventNamespace)
        
        //Create sort descriptor to sort retrieved Events by Date, descending
        let sortDescriptor = NSSortDescriptor(key: Constants.EventAttributes.date.rawValue,
            ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        //Execute Fetch request returns result as array or
        var fetchedResults: Array<Event>
        do {
            fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Event]
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDate error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Event>()
        }
        
        return fetchedResults
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
        let fetchRequest = NSFetchRequest(entityName: Constants.eventNamespace)
        
        // Execute the fetch request
        let fetchedResults: Array<Event>
        var succes = false
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
            succes = true
        } catch let fetchError as NSError {
            print("updateAllEventAttendees error: \(fetchError.localizedDescription)")
            succes = false
        }
        
        return succes
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
        
        //Persist new Event to database (via Managed Object Context Layer.
        var succes = false
        do {
            try context.save()
            succes = true
        } catch let fetchError as NSError {
            print("updateEventItemDetails error: \(fetchError.localizedDescription)")
            succes = false
        }
        
        return succes
    }
    
    // MARK: Delete
    
    /**
        Delete all items of Entity: Event, from persistence layer.
    
        :returns: bool check whether no items are stored anymore
    */
    func deleteAllItems()  -> Bool {
        
        //Persist deletion
        var success = false
        do {
            let retrievedItems = retrieveAllItems()
            
            //Delete all event items from persistance layer
            for item in retrievedItems {
                context.deleteObject(item)
            }
            
            //Persist deletion to datastore
            try context.save()
            success = true
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDate error: \(fetchError.localizedDescription)")
            success = false
        }
        
        return success
    }
    
    /**
        Returns a String representation of retrieved event items in passed list.
    
        :param: List of Event items
        :returns: String representation of passed in list
    */
    func printEventList(eventList: Array<Event>) -> String {
        
        var outputStr = "<("
        var counter = 0
        
        for event: Event in eventList {
            counter++
            
            outputStr += "\n{\n"
            for attribute in Constants.EventAttributes.getAll {
                if(event.valueForKey(attribute.rawValue) != nil) {
                    outputStr +=
                    "\(attribute.rawValue): \(event.valueForKey(attribute.rawValue))"
                }
            }
            
            if counter < eventList.count{
                outputStr += "\n}, "
            } else {
                outputStr += "\n}"
            }
        }
        
        return outputStr + ")>\n"
    }
}