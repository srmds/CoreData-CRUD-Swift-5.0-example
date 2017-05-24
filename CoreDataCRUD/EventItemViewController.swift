//
//  EventItemViewController.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import UIKit

/**
    EventItem View Controller, contains detailed view of a selected Event.
*/
class EventItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    //placeholder for event endpoint
    fileprivate var eventAPI: EventAPI!

    //Reference to selected event to pass to details view
    var selectedEventItem: Event!

    @IBOutlet weak var eventTitleLabel: UITextField! { didSet { eventTitleLabel.delegate = self } }
    @IBOutlet weak var eventVenueLabel: UITextField! { didSet { eventVenueLabel.delegate = self } }
    @IBOutlet weak var eventCityLabel: UITextField! { didSet { eventCityLabel.delegate = self } }
    @IBOutlet weak var eventCountryLabel: UITextField! { didSet { eventCountryLabel.delegate = self } }
    @IBOutlet weak var eventFBURLLabel: UITextField! { didSet { eventFBURLLabel.delegate = self } }
    @IBOutlet weak var eventTicketURL: UITextField! { didSet { eventTicketURL.delegate = self } }
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var scrollViewContainer: UIScrollView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var attendeesTableView: UITableView!

    fileprivate let idNamespace  = EventAttributes.eventId.rawValue
    fileprivate let titleNamespace  = EventAttributes.title.rawValue
    fileprivate let dateNamespace  = EventAttributes.date.rawValue
    fileprivate let venueNamespace  = EventAttributes.venue.rawValue
    fileprivate let cityNamespace  = EventAttributes.city.rawValue
    fileprivate let countryNamespace  = EventAttributes.country.rawValue
    fileprivate let fbURLNamespace  = EventAttributes.fb_url.rawValue
    fileprivate let ticketURLNamespace  = EventAttributes.ticket_url.rawValue
    fileprivate let attendeesNamespace  = EventAttributes.attendees.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func setup() {
        self.eventAPI = EventAPI.sharedInstance

        attendeesTableView.delegate = self
        attendeesTableView.dataSource = self

        if(self.selectedEventItem != nil) {
            setFieldValues()
        }
    }

    // MARK Actions

    /**
        Call endpoint save event handler, pass this event together with
        populated dictionary from field values.
    */
    @IBAction func eventSaveButtonTapped(_ sender: UIBarButtonItem) {
        if(selectedEventItem != nil) { //existing event
            eventAPI.updateEvent(selectedEventItem, newEventItemDetails:getFieldValues())
        } else { //new event
            //Input details
            var newDetails = getFieldValues()

            //Generate UUID, add it to dictionary
            newDetails[idNamespace] =  UUID().uuidString as NSObject?

            //Set initial list to empty list
            newDetails[attendeesNamespace] =  [AnyObject]() as NSObject?

            eventAPI.saveEvent(newDetails)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

    /**
        Set all fields text to a predefined default value.
    */
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        let defaultValue = "Live long and prosper 🖖🏾" // need to change to empty String ;p
        eventTitleLabel.text = defaultValue
        eventVenueLabel.text = defaultValue
        eventCityLabel.text = defaultValue
        eventCountryLabel.text = defaultValue
        eventFBURLLabel.text = defaultValue
        eventTicketURL.text = defaultValue
        eventDatePicker.date = Date()
    }

    /**
        Delete event item from datastore.
    */
    @IBAction func deleteEventButtonTapped(_ sender: UIButton) {
        if(selectedEventItem != nil) {
            eventAPI.deleteEvent(selectedEventItem)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

    // MARK: Textfield delegates

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollViewContainer.setContentOffset(CGPoint.zero, animated: true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollViewContainer.setContentOffset(CGPoint(x: scrollViewContainer.frame.origin.x, y: textField.frame.origin.y - 8), animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    // MARK Utility methods

    /**
        Set field values for passed on event item.
    */
    fileprivate func setFieldValues() {
        eventTitleLabel.text = selectedEventItem.title
        eventVenueLabel.text = selectedEventItem.venue
        eventCityLabel.text = selectedEventItem.city
        eventCountryLabel.text = selectedEventItem.country
        eventFBURLLabel.text = selectedEventItem.fb_url as? String
        eventTicketURL.text = selectedEventItem.ticket_url as? String
        eventDatePicker.date = selectedEventItem.date as Date
    }

    /**
        Populates all fields in to dictionary
    */
    fileprivate func getFieldValues() -> Dictionary<String, NSObject> {

        var fieldDetails = [String: NSObject]()
        fieldDetails[titleNamespace] = eventTitleLabel.text as NSObject?
        fieldDetails[dateNamespace] = Date() as NSObject?
        fieldDetails[venueNamespace] = eventVenueLabel.text as NSObject?
        fieldDetails[cityNamespace] = eventCityLabel.text as NSObject?
        fieldDetails[countryNamespace] = eventCountryLabel.text as NSObject?
        fieldDetails[fbURLNamespace] = eventFBURLLabel.text as NSObject?
        fieldDetails[ticketURLNamespace] = eventTicketURL.text as NSObject?
        fieldDetails[dateNamespace] = eventDatePicker.date as NSObject?

        return fieldDetails
    }

    @IBAction func switchSegmentTapped(_ sender: AnyObject) {

        if segmentController.selectedSegmentIndex == 0 {
            attendeesTableView.isHidden = true
            scrollViewContainer.isHidden = false

            if selectedEventItem != nil {
                self.title = "Edit event"
            } else {
                self.title = "Add event"
            }
        }

        if segmentController.selectedSegmentIndex == 1 {
            scrollViewContainer.isHidden = true
            attendeesTableView.isHidden = false

            if selectedEventItem != nil {
                self.title = String(format: "Attendees (%i)", selectedEventItem.attendees.count)
            } else {
                self.title = "Attendees (0)"
            }
        }
    }

    // MARK: Attendees TableView Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int

        if selectedEventItem != nil {
            count = selectedEventItem.attendees.count
        } else {
            count = 0
        }

        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attendeesTableCellIdentifier = "attendeesItemCell"
        let attendeeCell = tableView.dequeueReusableCell(withIdentifier: attendeesTableCellIdentifier, for: indexPath)
        attendeeCell.textLabel!.text = selectedEventItem.attendees[indexPath.row] as? String

        return attendeeCell
    }

}
