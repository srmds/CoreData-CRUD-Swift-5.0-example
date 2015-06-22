//
//  Replicator.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import Foundation

class LocalReplicator : ReplicatorProtocol {
    
    private var eventAPI: EventAPI!
    private var dataSource = "events"

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
        Pull event data from a given resource
    */
    func pull() -> Bool {
        var success:Bool = false
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            success = self.processData()
            
            if (success) {
                dispatch_async(dispatch_get_main_queue()) {
                    success = true
                    NSNotificationCenter.defaultCenter().postNotificationName("updateEventTableData", object: nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    success = false
                    NSNotificationCenter.defaultCenter().postNotificationName("updateEventTableData", object: nil)
                }
            }
        })
        
        return success
    }
    
    /**
        Process data from a given resource Event objects and assigning
        property values and calling the managed object layer to persist
        to the datastore.
    */
    internal func processData() -> Bool {
        let filemgr = NSFileManager.defaultManager()
        let currPath = NSBundle.mainBundle().pathForResource(dataSource, ofType: "json")
        var jsonResult:AnyObject! = nil
        var success:Bool = false

        do {
            let jsonData = NSData(contentsOfFile: currPath!)!

                if filemgr.fileExistsAtPath(currPath!) {
                    
                    jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                    
                    if let eventList = jsonResult  {
                        
                        for index in 0...eventList.count - 1 {
                            
                            var eventItem:Dictionary<String, NSObject> = eventList[index] as! Dictionary<String, NSObject>
                            
                            //Create additional event item properties
                            eventItem[Constants.EventAttributes.date.rawValue] = parseDate(eventItem[Constants.EventAttributes.date.rawValue] as! String)
                            eventItem[Constants.EventAttributes.eventId.rawValue] = NSUUID().UUIDString
                            eventItem[Constants.EventAttributes.fb_url.rawValue] = "https://www.facebook.com/events/00000000"
                            eventItem[Constants.EventAttributes.ticket_url.rawValue] = "https://shop.eventtickets.com/00000"
                            eventItem[Constants.EventAttributes.attendees.rawValue] = getSemiRandomGeneratedAttendeesList()
                            
                            eventAPI.saveEvent(eventItem)
                        }
                        
                        success = true
                    } else {
                        success = false
                    }
            }
        } catch let fetchError as NSError {
            print("pull error: \(fetchError.localizedDescription)")
            success = false
        }
        
        return success
    }
    
    // MARK: Utility methods
    
    /**
    Get a date as formatted String
    */
    private func parseDate(dateStr: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.dateFromString(dateStr)!
    }
    
    /**
    Generate (pseudo)random attendeeslist of (pseudo)random size and (pseudo)random attendees.
    
    :see: https://en.wikipedia.org/wiki/Hardware_random_number_generator
    for true randomness ;)
    
    :returns: (pseudo)random generated attendeeslist
    */
    private func getSemiRandomGeneratedAttendeesList() -> Array<String> {
        let optionalAttendees = [
            "Yoda",
            "HAL 9000",
            "Gizmo",
            "Optimus Prime",
            "Marvin the Paranoid Android",
            "ET",
            "Bender",
            "Narcissus",
            "Frodo",
            "Esscher",
            "Lothar Collatz",
            "Foo",
            "Bar",
            "Tweety"
        ]
        
        var attendeesList = [String]()
        let listSize:Int =  Int(arc4random_uniform(UInt32(truncatingBitPattern: optionalAttendees.count)))
        
        for _ in 0...listSize {
            let itemIndex:Int =  Int(arc4random_uniform(UInt32(truncatingBitPattern: listSize)))
            let item:String = optionalAttendees[itemIndex]
            if !attendeesList.contains(item) {
                attendeesList.append(item)
            }
        }
        
        return attendeesList
    }    
    
}