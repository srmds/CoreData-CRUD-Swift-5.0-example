//
//  Replicator.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import Foundation

/**
    Local Replicator handles reading and parsing JSON data from a local file and calls the Core Data Stack,
    (via EventAPI) to actually create Core Data Entities and persist to SQLite Datastore.
*/
class LocalReplicator : ReplicatorProtocol {
    
    private var eventAPI: EventAPI!

    //Utilize Singleton pattern by instanciating Replicator only once.
    class var sharedInstance: LocalReplicator {
        struct Singleton {
            static let instance = LocalReplicator()
        }
        
        return Singleton.instance
    }
    
    init() {
        self.eventAPI = EventAPI.sharedInstance
    }
    
    /** 
        Pull event data from a given resource, posts a notification to update 
        datasource of a given/listening ViewController/UITableView
    
        - Returns: Void
    */
    func fetchData() {
        //Read JSON file in seperate thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            // read JSON file, parse JSON data
            self.processData(self.readFile())
            
            // Post notification to update datasource of a given ViewController/UITableView
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName("updateEventTableData", object: nil)
            }
        })
    }
    
    /**
        Read JSON data from a local file in the Resources dir.
    
        - Returns: AnyObject The contents of the JSON file.
    */
    func readFile() -> AnyObject {
        let dataSourceFilename:String = "events"
        let dataSourceFilenameExtension:String = "json"
        let filemgr = NSFileManager.defaultManager()
        let currPath = NSBundle.mainBundle().pathForResource(dataSourceFilename, ofType: dataSourceFilenameExtension)
        var jsonResult:AnyObject! = nil
        
        do {
            let jsonData = NSData(contentsOfFile: currPath!)!
            
            if filemgr.fileExistsAtPath(currPath!) {
                jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            } else {
                print("\(dataSourceFilename).\(dataSourceFilenameExtension)) does not exist, therefore cannot read JSON data.")
            }
        } catch let fetchError as NSError {
            print("read file error: \(fetchError.localizedDescription)")
        }
        
        return jsonResult
    }
    
    /**
        Process data from a given resource Event objects and assigning
        (additional) property values and calling the Event API to persist Events
        to the datastore.
    
        - Parameter jsonResult: The JSON content to be parsed and stored to Datastore.
        - Returns: Void
    */
    func processData(jsonResult:AnyObject?) {
        var retrievedEvents = [Dictionary<String,AnyObject>]()
        
        if let eventList = jsonResult  {
            for index in 0..<eventList.count {
                var eventItem:Dictionary<String, AnyObject> = eventList[index] as! Dictionary<String, AnyObject>
                
                //Create additional event item properties:
                
                //Generate event UUID
                eventItem[EventAttributes.eventId.rawValue] = NSUUID().UUIDString
                
                //Generate semi random generated attendeeslist
                eventItem[EventAttributes.attendees.rawValue] = AttendeesGenerator.getSemiRandomGeneratedAttendeesList()

                retrievedEvents.append(eventItem)
            }
        }
        
        //Call Event API to persist Event list to Datastore
        eventAPI.saveEventsList(retrievedEvents)
    }
}