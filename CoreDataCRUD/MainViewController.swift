//
//  CoreDataCRUD
//  EventController.swift
//  Written by Steven R.
//

import UIKit
import Foundation

/**
    Main Viewcontroller, outputs Event Manager logs to 
    view.
*/

enum EventsError: ErrorType {
    case retrieveError
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var outputLogTextView: UITextView!
    
    //Implicitly unwrapped reference to the Managed Object Context Layer
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //Implicitly unwrapped placeholder for the Controller
    var eventAPI: EventAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize and reference to Controller, pass in managedObjectContext
        //via the EventController constructor
        self.eventAPI = EventAPI.sharedInstance

       doCRUD()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
        Utilizes the EventController to demonstrate simple CRUD operations.
    */
    private func doCRUD() {
        
        var outputText :String!

        //Create
        
        //Creates some Event entities and persists to datastore
        eventAPI.createAndPersistTestData()
        
        //Read
        
        //Retrieve all Items of an entity type
        var retrievedItems = eventAPI.getAll()
        outputText = "Retrieved items count \(retrievedItems.count)\nResults:\n\(eventAPI.printList(retrievedItems))"
        print(outputText)
        self.outputLogTextView.text = outputText
        
        //Retrieve a single event found by its eventId
        let uuidOfItemToFind = retrievedItems[0].eventId
        let retrievedEventItem = eventAPI.getById(uuidOfItemToFind)
        outputText = outputText + "\n\nRetrieved Items found by it's Id:\n \(eventAPI.printList(retrievedEventItem))"
        print(outputText)
        self.outputLogTextView.text = outputText

        //Retrieve events sorted by Date
        let retrievedItemsSortedByDate = eventAPI.getSortedByDate()
        outputText = outputText + "\n\nRetrieved Items sorted by Date:\n \(eventAPI.printList(retrievedItemsSortedByDate))"
        outputLogTextView.text = outputText
        
        //Update
        
        //Update all stored (batch update) events attendees list
        eventAPI.updateAllEventAttendees()
        //Retrieve all Items of an entity type after batch update
        retrievedItems = eventAPI.getAll()
        outputText = outputText + "Retrieved items count \(retrievedItems.count)\nResults after batch update:\n\(eventAPI.printList(retrievedItems))"
        print(outputText)
        
        //Delete
        
        //Delete all stored items in persistence layer
        let success = eventAPI.deleteAll()
        outputText = outputText + "\n\nDeleted all event items, succeeded: \(success)"
        outputLogTextView.text = outputText
    }
    
}