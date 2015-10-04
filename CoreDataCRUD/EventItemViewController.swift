//
//  EventItemViewController.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import UIKit

/**
    EventItem View Controller, contains detailed view of a selected Event.
*/
class EventItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //placeholder for event endpoint
    private var eventAPI: EventAPI!

    //Reference to selected event to pass to details view
    var selectedEventItem:Event!
   
    @IBOutlet weak var eventTitleLabel: UITextField!{ didSet { eventTitleLabel.delegate = self } }
    @IBOutlet weak var eventVenueLabel: UITextField!{ didSet { eventVenueLabel.delegate = self } }
    @IBOutlet weak var eventCityLabel: UITextField!{ didSet { eventCityLabel.delegate = self } }
    @IBOutlet weak var eventCountryLabel: UITextField!{ didSet { eventCountryLabel.delegate = self } }
    @IBOutlet weak var eventFBURLLabel: UITextField!{ didSet { eventFBURLLabel.delegate = self } }
    @IBOutlet weak var eventTicketURL: UITextField!{ didSet { eventTicketURL.delegate = self } }
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var scrollViewContainer: UIScrollView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var attendeesTableView: UITableView!
    
    private let idNamespace  = EventAttributes.eventId.rawValue
    private let titleNamespace  = EventAttributes.title.rawValue
    private let dateNamespace  = EventAttributes.date.rawValue
    private let venueNamespace  = EventAttributes.venue.rawValue
    private let cityNamespace  = EventAttributes.city.rawValue
    private let countryNamespace  = EventAttributes.country.rawValue
    private let fbURLNamespace  = EventAttributes.fb_url.rawValue
    private let ticketURLNamespace  = EventAttributes.ticket_url.rawValue
    private let attendeesNamespace  = EventAttributes.attendees.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        self.eventAPI = EventAPI.sharedInstance
        
        attendeesTableView.delegate = self
        attendeesTableView.dataSource = self
        
        if(self.selectedEventItem != nil){
            setFieldValues()
        }
    }
    
    // MARK Actions
    
    /**
        Call endpoint save event handler, pass this event together with
        populated dictionary from field values.
    */
    @IBAction func eventSaveButtonTapped(sender: UIBarButtonItem) {
        if(selectedEventItem != nil){ //existing event
            eventAPI.updateEvent(selectedEventItem, newEventItemDetails:getFieldValues())
        } else { //new event
            //Input details
            var newDetails = getFieldValues()
            
            //Generate UUID, add it to dictionary
            newDetails[idNamespace] =  NSUUID().UUIDString
            
            //Set initial list to empty list
            newDetails[attendeesNamespace] = []
            
            eventAPI.saveEvent(newDetails)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /**
        Set all fields text to a predefined default value.
    */
    @IBAction func clearButtonTapped(sender: AnyObject) {
        let defaultValue = "Live long and prosper 🖖🏾" // need to change to empty String ;p
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
            eventAPI.deleteEvent(selectedEventItem)
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
        fieldDetails[titleNamespace] = eventTitleLabel.text
        fieldDetails[dateNamespace] = NSDate()
        fieldDetails[venueNamespace] = eventVenueLabel.text
        fieldDetails[cityNamespace] = eventCityLabel.text
        fieldDetails[countryNamespace] = eventCountryLabel.text
        fieldDetails[fbURLNamespace] = eventFBURLLabel.text
        fieldDetails[ticketURLNamespace] = eventTicketURL.text
        fieldDetails[dateNamespace] = eventDatePicker.date
        
        return fieldDetails
    }
    
    
    @IBAction func switchSegmentTapped(sender: AnyObject) {
        
        if segmentController.selectedSegmentIndex == 0 {
            attendeesTableView.hidden = true
            scrollViewContainer.hidden = false
            
            if selectedEventItem != nil {
                self.title = "Edit event"
            } else{
                self.title = "Add event"
            }
        }
        
        if segmentController.selectedSegmentIndex == 1 {
            scrollViewContainer.hidden = true
            attendeesTableView.hidden = false
            
            if selectedEventItem != nil {
                self.title = String(format: "Attendees (%i)", selectedEventItem.attendees.count)
            } else {
                self.title = "Attendees (0)"
            }
        }
    }
    
    // MARK: Attendees TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int
    
        if selectedEventItem != nil {
            count = selectedEventItem.attendees.count
        } else {
            count = 0
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let attendeesTableCellIdentifier = "attendeesItemCell"
        let attendeeCell = tableView.dequeueReusableCellWithIdentifier(attendeesTableCellIdentifier, forIndexPath: indexPath)
        attendeeCell.textLabel!.text = selectedEventItem.attendees[indexPath.row] as? String
        
        return attendeeCell
    }
    
}
