//
//  Replicator.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import Foundation

/**
    Local Replicator handles reading and parsing JSON data from a local file and calls the Core Data Stack,
    (via EventAPI) to actually create Core Data Entities and persist to SQLite Datastore.
*/
class LocalReplicator: ReplicatorProtocol {

    fileprivate var eventAPI: EventAPI!

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
        DispatchQueue.global(qos: .background).async {
            // read JSON file, parse JSON data
            self.processData(self.readFile() as AnyObject?)

            // Post notification to update datasource of a given ViewController/UITableView
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateEventTableData"), object: nil)
            }

        }
    }

    /**
        Read JSON data from a local file in the Resources dir.
    
        - Returns: AnyObject The contents of the JSON file.
    */
    func readFile() -> Any {
        let dataSourceFilename: String = "events"
        let dataSourceFilenameExtension: String = "json"
        let filemgr = FileManager.default
        let currPath = Bundle.main.path(forResource: dataSourceFilename, ofType: dataSourceFilenameExtension)
        var jsonResult:Any! = nil

        do {
            let jsonData: Data = try! Data(contentsOf: URL(fileURLWithPath: currPath!))

            if filemgr.fileExists(atPath: currPath!) {
                jsonResult = try JSONSerialization.jsonObject(with: jsonData)
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
    func processData(_ jsonResult: AnyObject?) {
        var retrievedEvents = [Dictionary<String, AnyObject>]()

        if let eventList = jsonResult {
            for index in 0..<eventList.count {
                var eventItem: Dictionary<String, AnyObject> = eventList[index] as! Dictionary<String, AnyObject>

                //Create additional event item properties:

                //Prefix title with local(ly) retrieved label
                eventItem[EventAttributes.title.rawValue] = "[LOCAL] \(eventItem[EventAttributes.title.rawValue]!)"  as AnyObject?

                //Generate event UUID
                eventItem[EventAttributes.eventId.rawValue] = UUID().uuidString as AnyObject?

                //Generate semi random generated attendeeslist
                eventItem[EventAttributes.attendees.rawValue] = AttendeesGenerator.getSemiRandomGeneratedAttendeesList() as AnyObject?

                retrievedEvents.append(eventItem)
            }
        }

        //Call Event API to persist Event list to Datastore
        eventAPI.saveEventsList(retrievedEvents as Array<AnyObject>)
    }
}
