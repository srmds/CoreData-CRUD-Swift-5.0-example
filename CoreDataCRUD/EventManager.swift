//
//  CoreDataCRUD
//  EventController.swift
//  Written by Steven R.
//

import CoreData

//Enum for Event Entity member fields
enum EventEntityAttributes : String {
    case
    eventId    = "eventId",
    title      = "title",
    date       = "date",
    venue      = "venue",
    city       = "city",
    country    = "country",
    attendees  = "attendees",
    fb_url      = "fb_url",
    ticket_url = "ticket_url"
    
    static let getAll = [eventId, title, date, venue, city, country, attendees, fb_url,ticket_url]
}

let eventNamespace = "Event"

/**
    A  manager that allows CRUD operations on the persistence store
    with an Event entity.
*/
class EventManager {
    
    var context: NSManagedObjectContext
    
    //Event Constructor
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    /**
        Creates a new Managed object and persists to datastore.
    
        :param: eventDetails Dictionary<String, NSObject> containing
                 eventDetails.
    */
    func saveNewItem(eventDetails: Dictionary<String, NSObject>) -> Bool {
        
        //Reference to Event entity
        let entity = NSEntityDescription.entityForName(eventNamespace,
                        inManagedObjectContext:context)
        
        //Create new Object of Event entity
        let eventItem = Event(entity: entity!,
            insertIntoManagedObjectContext: context)
        
        //Assign field values,this enforces an implicit check to only set
        //(non nil) values for existing keys
        for (key, value) in eventDetails {
            for attribute in EventEntityAttributes.getAll {
                if(key == attribute.rawValue){
                    eventItem.setValue(value, forKey: key)
                }
            }
        }
        
        //Persist new Event to database (via Managed Object Context Layer)
        var error: NSError? = nil
        var succeeded = !context.save(&error)
        
        print("Saved:\n'\(eventItem)'\n\nto datastore on: \(eventItem.date)")
        
        return succeeded
    }
    
    
    /**
        Retrieves all event items stored in the persistence layer.
    
        :returns:  Array<Event> with found events in datastore
    */
    func retrieveAllItems() -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: eventNamespace)
        
        //Execute Fetch request returns result as array or
        //if failed returns error obj.
        var error: NSError? = nil
        let fetchedResults =
        context.executeFetchRequest(fetchRequest, error: &error)
        
        return fetchedResults! as! Array<Event>
    }
    
    /**
        Retrieve an event found by it's stored id.
    
        :param: eventId of item to retrieve
        :returns: event item or nil if event is not found
    */
    func retrieveById(eventId: NSString) -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName:eventNamespace)
        fetchRequest.returnsObjectsAsFaults = false;
        
        //Add a predicate to filter by eventId
        
        let findByIdPredicate = NSPredicate(format: "eventId = %@", eventId)
        fetchRequest.predicate = findByIdPredicate
        
        //Execute Fetch request returns result as array or
        var error: NSError? = nil
        let fetchedResults =
        context.executeFetchRequest(fetchRequest, error: &error)
        
        return fetchedResults! as! Array<Event>
    }
    
    /**
        Retrieves all event items stored in the persistence layer
        and sort it by Date.
    
        :returns:  Array<Event> with found events in datastore based on
                 sort descriptor, in this case Date.
    */
    func retrieveItemsSortedByDate() -> Array<Event> {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest(entityName: eventNamespace)
        
        //Create sort descriptor to sort retrieved Events by Date, ascending
        let sortDescriptor
        = NSSortDescriptor(key: EventEntityAttributes.date.rawValue,
            ascending: false)
        
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        var error: NSError? = nil
        let fetchedResults =
        context.executeFetchRequest(fetchRequest, error: &error)
        
        return fetchedResults! as! Array<Event>
    }
    
    /**
        Delete all items of Entity: Event, from persistence layer.
    
        :returns: bool check whether no items are stored anymore
    */
    func deleteAllItems() -> Bool {
        
        //Retrieve all event items
        var retrievedItems = retrieveAllItems()
        
        //Delete all event items from persistance layer
        for item in retrievedItems {
            context.deleteObject(item)
        }
        
        //Persist deletion
        var error: NSError? = nil
        context.save(&error)
        
        //Check that retrieving event items should return none
        return (retrieveAllItems().count == 0 ? true :false)
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
            for attribute in EventEntityAttributes.getAll {
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