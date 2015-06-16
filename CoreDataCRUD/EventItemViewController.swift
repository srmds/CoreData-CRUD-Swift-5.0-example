//
//  EventItemViewController.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import UIKit

class EventItemViewController: UIViewController,UITextFieldDelegate {
    
    //placeholder for event endpoint
    private var eventAPI: EventAPI!
    
    //Reference to selected event to pass to details view
    internal var selectedEventItem:Event!
    
    @IBOutlet weak var eventTitleLabel: UITextField!{ didSet { eventTitleLabel.delegate = self } }
    @IBOutlet weak var eventVenueLabel: UITextField!{ didSet { eventVenueLabel.delegate = self } }
    @IBOutlet weak var eventCityLabel: UITextField!{ didSet { eventCityLabel.delegate = self } }
    @IBOutlet weak var eventCountryLabel: UITextField!{ didSet { eventCountryLabel.delegate = self } }
    @IBOutlet weak var eventFBURLLabel: UITextField!{ didSet { eventFBURLLabel.delegate = self } }
    @IBOutlet weak var eventTicketURL: UITextField!{ didSet { eventTicketURL.delegate = self } }
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var scrollViewContainer: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.eventAPI = EventAPI.sharedInstance
        
        if(self.selectedEventItem != nil){
            setFieldValues()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK Actions
    
    /**
    Call endpoint save event handler, pass this event together with
    populated dictionary from field values.
    */
    @IBAction func eventSaveButtonTapped(sender: UIBarButtonItem) {
        if(selectedEventItem != nil){
            eventAPI.updateEvent(selectedEventItem, updateDetails:getFieldValues())
        } else {
            //Input details
            var newDetails = getFieldValues()
            
            //Generate UUID, add it to dictionary
            newDetails[Constants.EventAttributes.eventId.rawValue] =  NSUUID().UUIDString
            
            eventAPI.saveEvent(newDetails)
            
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    /**
    Set all fields text to a predefined default value.
    */
    @IBAction func clearButtonTapped(sender: AnyObject) {
        let defaultValue = "Live long and prosper 🖖🏾" // need change to empty String ;p
        eventTitleLabel.text = defaultValue
        eventVenueLabel.text = defaultValue
        eventCityLabel.text = defaultValue
        eventCountryLabel.text = defaultValue
        eventFBURLLabel.text = defaultValue
        eventTicketURL.text = defaultValue
        eventDatePicker.date = NSDate()
    }
    
    /**
    Delete event item from datastore.
    */
    @IBAction func deleteEventButtonTapped(sender: UIButton) {
        if(selectedEventItem != nil){
            eventAPI.deleteItem(selectedEventItem)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: Textfield delegates
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollViewContainer.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollViewContainer.setContentOffset(CGPoint(x: scrollViewContainer.frame.origin.x, y: textField.frame.origin.y - 8), animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK Utility methods
    
    /**
    Set field values for passed on event item.
    */
    private func setFieldValues(){
        eventTitleLabel.text = selectedEventItem.title
        eventVenueLabel.text = selectedEventItem.venue
        eventCityLabel.text = selectedEventItem.city
        eventCountryLabel.text = selectedEventItem.country
        eventFBURLLabel.text = selectedEventItem.fb_url as? String
        eventTicketURL.text = selectedEventItem.ticket_url as? String
        eventDatePicker.date = selectedEventItem.date
    }
    
    /**
    Populates all fields in to dictionary
    */
    private func getFieldValues() -> Dictionary<String, NSObject> {
        
        var fieldDetails = [String: NSObject]()
        fieldDetails[Constants.EventAttributes.title.rawValue] = eventTitleLabel.text
        fieldDetails[Constants.EventAttributes.date.rawValue] = NSDate()
        fieldDetails[Constants.EventAttributes.venue.rawValue] = eventVenueLabel.text
        fieldDetails[Constants.EventAttributes.city.rawValue] = eventCityLabel.text
        fieldDetails[Constants.EventAttributes.country.rawValue] = eventCountryLabel.text
        fieldDetails[Constants.EventAttributes.fb_url.rawValue] = eventFBURLLabel.text
        fieldDetails[Constants.EventAttributes.ticket_url.rawValue] = eventTicketURL.text
        fieldDetails[Constants.EventAttributes.date.rawValue] =
            eventDatePicker.date
        
        return fieldDetails
    }
    
}
