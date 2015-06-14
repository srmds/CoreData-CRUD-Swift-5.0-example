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
    
    //Output textview for logs
    @IBOutlet  var outputLogTextView: UITextView!
    
    //Implicitly unwrapped placeholder for the Controller
    var eventAPI: EventAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventAPI = EventAPI.sharedInstance
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
        Utilizes the EventController to demonstrate simple CRUD operations.
    */

    //Creates some Event entities and persists to datastore
    @IBAction func createTestDataTapped(sender: UIButton) {
        if eventAPI.createAndPersistTestData() {
            var outputText :String!
            outputText = "Successfully created test items. Click get all events to retrieve them."
            print(outputText)
            self.outputLogTextView.text = outputText
        }
    }
    
    //Retrieve all Items of an entity type
    @IBAction func getAllTapped(sender: UIButton) {
        var outputText :String!
        let retrievedItems = eventAPI.getAll()
        outputText = "Retrieved items count \(retrievedItems.count)\nResults:\n\(eventAPI.printList(retrievedItems))"
        print(outputText)
        self.outputLogTextView.text = outputText
    }
    
    //Retrieve events sorted by Date
    @IBAction func getAllSortedTapped(sender: AnyObject) {
        var outputText :String!
        let retrievedItemsSortedByDate = eventAPI.getSortedByDate()
        outputText = "Retrieved Items sorted by Date:\n \(eventAPI.printList(retrievedItemsSortedByDate))"
        outputLogTextView.text = outputText
    }
    
    //Retrieve a single event found by its eventId
    @IBAction func getByIdTapped(sender: UIButton) {
        var outputText :String!
        let retrievedItems = eventAPI.getAll()
        let uuidOfItemToFind = retrievedItems[0].eventId
        let retrievedEventItem = eventAPI.getById(uuidOfItemToFind)
        outputText = "Retrieved Items found by it's Id:\n \(eventAPI.printList(retrievedEventItem))"
        print(outputText)
        outputLogTextView.text = outputText
    }
    
    //Update all stored (batch update) events attendees list
    @IBAction func updateAllTapped(sender: UIButton) {
        var outputText :String!
        eventAPI.updateAllEventAttendees()
        let retrievedItems = eventAPI.getAll()
        outputText = "Retrieved items count \(retrievedItems.count)\nResults after batch update:\n\(eventAPI.printList(retrievedItems))"
        print(outputText)
        outputLogTextView.text = outputText
    }
    
    //Delete all stored items in persistence layer
    @IBAction func deleteAllTapped(sender: UIButton) {
        var outputText :String!
        let success = eventAPI.deleteAll()
        outputText = "\n\nDeleted all event items, succeeded: \(success)"
        outputLogTextView.text = outputText
    }
    
}