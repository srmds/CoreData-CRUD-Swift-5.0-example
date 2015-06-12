//
//  CoreDataCRUD
//  EventController.swift
//  Written by Steven R.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var outputLogTextView: UITextView!
    
    //Implicitly unwrapped reference to the Managed Object Context Layer
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    //Implicitly unwrapped placeholder for the Controller
    var eventManager: EventManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize and reference to Controller, pass in managedObjectContext
        //via the EventController constructor
        self.eventManager = EventManager(context: self.context)
        
        doCRUD()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Utilizes the EventController to demonstrate simple CRUD operations
    private func doCRUD() {
        
        //Create data that is persisted to datastore
        createAndPersistTestData()
        
        var outputText :String!
        
        //Retrieve all Items of an entity type
        var retrievedItems = eventManager.retrieveAllItems()
        outputText = "Retrieved items count \(retrievedItems.count)\nResults:\n\(eventManager.printEventList(retrievedItems))"
        println(outputText)
        self.outputLogTextView.text = outputText
        
        //Retrieve a single event found by its eventId
        var uuidOfItemToFind = retrievedItems[0].eventId
        var retrievedEventItem = eventManager.retrieveById(uuidOfItemToFind)
        outputText = outputText + "\n\nRetrieved Items found by it's Id:\n \(eventManager.printEventList(retrievedEventItem))"
        println(outputText)
        self.outputLogTextView.text = outputText

        //Retrieve events sorted by Date
        var retrievedItemsSortedByDate = eventManager.retrieveItemsSortedByDate()
        outputText = outputText + "\n\nRetrieved Items sorted by Date:\n \(eventManager.printEventList(retrievedItemsSortedByDate))"
        outputLogTextView.text = outputText

        //Delete all stored items in persistence layer
        var success = eventManager.deleteAllItems()
        outputText = outputText + "\n\nDeleted all event items, succeeded: \(success)"
        outputLogTextView.text = outputText
    }
    
    private func createAndPersistTestData() {
        
        //Create some Date offsets to be able to sort on
        let today = NSDate()
        let tomorrow: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .CalendarUnitDay,
            value: 1,
            toDate: today,
            options: NSCalendarOptions(0))!
        
        //Create a Dictionary, key - values with event details
        var eventDetailsItem1 = [
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
        
        var eventDetailsItem2 = [
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
        var success = false
        
        success = eventManager.saveNewItem(eventDetailsItem1)
        print(" succeeded: \(success)\n\n")
        
        success = eventManager.saveNewItem(eventDetailsItem2)
        print(" succeeded: \(success)\n\n")
    }
}