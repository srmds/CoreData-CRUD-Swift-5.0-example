//
//  EventItemViewController.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import UIKit

class EventItemViewController: UIViewController {

    //placeholder for event endpoint
    var eventAPI: EventAPI!
    
    //Reference to selected event to pass to details view
    var selectedEventItem:Event!
    
    @IBOutlet weak var eventTitleLabel: UITextField!
    @IBOutlet weak var eventVenueLabel: UITextField!
    @IBOutlet weak var eventCityLabel: UITextField!
    @IBOutlet weak var eventCountryLabel: UITextField!
    @IBOutlet weak var eventFBURLLabel: UITextField!
    @IBOutlet weak var eventTicketURL: UITextField!
    
    //Call endpoint save event handler, pass this event togehter with
    //populated dictionary from field values.
    @IBAction func eventSaveButtonTapped(sender: UIBarButtonItem) {
        if(selectedEventItem != nil){
            eventAPI.updateEvent(selectedEventItem, updateDetails:getFieldValues())
        } else {
            eventAPI.saveEvent(getFieldValues())
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func clearButtonTapped(sender: AnyObject) {
        let defaultValue = "Live long and prosper 🖖🏾"
        eventTitleLabel.text = defaultValue
        eventVenueLabel.text = defaultValue
        eventCityLabel.text = defaultValue
        eventCountryLabel.text = defaultValue
        eventFBURLLabel.text = defaultValue
        eventTicketURL.text = defaultValue
    }
    
    
    @IBAction func deleteEventButtonTapped(sender: UIButton) {
        if(selectedEventItem != nil){
            eventAPI.deleteItem(selectedEventItem)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.eventAPI = EventAPI.sharedInstance
        
        if(self.selectedEventItem != nil){
            eventTitleLabel.text = selectedEventItem.title
            eventVenueLabel.text = selectedEventItem.venue
            eventCityLabel.text = selectedEventItem.city
            eventCountryLabel.text = selectedEventItem.country
            eventFBURLLabel.text = selectedEventItem.fb_url as? String
            eventTicketURL.text = selectedEventItem.ticket_url as? String
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Populates all fields in to dictionary
    private func getFieldValues() -> Dictionary<String, NSObject> {

        var fieldDetails = [String: NSObject]()
        fieldDetails[Constants.EventAttributes.title.rawValue] = eventTitleLabel.text
        fieldDetails[Constants.EventAttributes.date.rawValue] = NSDate()
        fieldDetails[Constants.EventAttributes.venue.rawValue] = eventVenueLabel.text
        fieldDetails[Constants.EventAttributes.city.rawValue] = eventCityLabel.text
        fieldDetails[Constants.EventAttributes.country.rawValue] = eventCountryLabel.text
        fieldDetails[Constants.EventAttributes.fb_url.rawValue] = eventFBURLLabel.text
        fieldDetails[Constants.EventAttributes.ticket_url.rawValue] = eventTicketURL.text
        
        return fieldDetails
    }
}
