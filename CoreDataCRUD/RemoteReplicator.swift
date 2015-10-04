//
//  RemoteReplicator.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 04/10/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation

/**
    Remote Replicator handles calling remote datasource and parsing response JSON data and calls the Core Data Stack,
    (via EventAPI) to actually create Core Data Entities and persist to SQLite Datastore.
*/

class RemoteReplicator : ReplicatorProtocol {
    
    private var eventAPI: EventAPI!
    private var httpClient:HTTPClient!
    
    //Utilize Singleton pattern by instanciating Replicator only once.
    class var sharedInstance: RemoteReplicator {
        struct Singleton {
            static let instance = RemoteReplicator()
        }
        
        return Singleton.instance
    }
    
    init() {
        self.eventAPI = EventAPI.sharedInstance
        self.httpClient = HTTPClient()
    }
    
    /**
        Pull event data from a given Remote resource, posts a notification to update
        datasource of a given/listening ViewController/UITableView.
        
        - Returns: Void
    */
    func fetchData() {
        
        //Remote resource
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string: "https://www.dropbox.com/s/mq5o0f4fiyl0hwc/remote_events.json?dl=1")!)
        
        httpClient.doGet(request) { (data, error, httpStatusCode) -> Void in
            if httpStatusCode!.rawValue != HTTPStatusCode.OK.rawValue {
                print("\(httpStatusCode!.rawValue) \(httpStatusCode)")
                if data == nil {
                    print("data is nil")
                }
            }
            else {
                //Read JSON response in seperate thread
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    // read JSON file, parse JSON data
                    self.processData(data!)
                    
                    // Post notification to update datasource of a given ViewController/UITableView
                    dispatch_async(dispatch_get_main_queue()) {
                        NSNotificationCenter.defaultCenter().postNotificationName("updateEventTableData", object: nil)
                    }
                })
            }
        }
    }
    
    /**
        Process data from a given resource Event objects and assigning
        (additional) property values and calling the Event API to persist Events
        to the datastore.
        
        - Parameter jsonResult: The JSON content to be parsed and stored to Datastore.
        - Returns: Void
    */
    func processData(jsonResponse:AnyObject?) {
        
        let jsonData:NSData = jsonResponse as! NSData
        var jsonResult:AnyObject!
        
        do {
            jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
        } catch let fetchError as NSError {
            print("pull error: \(fetchError.localizedDescription)")
        }

        var retrievedEvents:[Dictionary<String,AnyObject>] = []
        
        if let eventList = jsonResult  {
            for index in 0..<eventList.count {
                var eventItem:Dictionary<String, AnyObject> = eventList[index] as! Dictionary<String, AnyObject>
                
                //Create additional event item properties:
                
                //Prefix title with remote(ly) retrieved label
                eventItem[EventAttributes.title.rawValue] = "[REMOTE] \(eventItem[EventAttributes.title.rawValue]!)"

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