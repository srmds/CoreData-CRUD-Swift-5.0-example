//
//  EventTableViewController.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import UIKit

class EventTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var eventList:Array<Event> = []
    private var filteredEventList:Array<Event> = []
    private var selectedEventItem : Event!
    private var resultSearchController:UISearchController!
    private var eventAPI: EventAPI!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initResultSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateEventTableData:", name: "updateEventTableData", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setStateLoading:", name: "setStateLoading", object: nil)
        self.eventAPI = EventAPI.sharedInstance
        self.tableView.setContentOffset(CGPointMake(0, 44),animated: true)
        self.eventList = eventAPI.getSortedByDateInRange()
        self.title = String(format: "Upcoming events (%i)",eventList.count)
        refreshTableData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active {
            return self.filteredEventList.count
        }
        
        return eventList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let eventCell =
        tableView.dequeueReusableCellWithIdentifier(Constants.CellIds.EventTableCell, forIndexPath: indexPath) as! EventTableViewCell
        
        let eventItem:Event!
        
        if resultSearchController.active {
            eventItem = filteredEventList[indexPath.row]
        } else {
            eventItem = eventList[indexPath.row]
        }
        
        eventCell.eventDateLabel.text = getFormattedDate(eventItem.date)
        eventCell.eventTitleLabel.text = eventItem.title
        eventCell.eventLocationLabel.text = "\(eventItem.venue) - \(eventItem.city) - \(eventItem.country)"
        eventCell.eventImageView.image = getEventImage(indexPath)
        
        return eventCell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let destination = segue.destinationViewController as? EventItemViewController
        
        if segue.identifier == Constants.SegueIds.showEventItem {
            /*
            Two options to pass selected Event to destination:
            
            1) Object passing since eventList contains Event objects:
            destination!.selectedEventItem = eventList[self.tableView.indexPathForSelectedRow!.row] as Event
            
            2) Utilize EventAPI, find Event by Id:
            destination!.selectedEventItem = eventAPI.getById(selectedEventItem.eventId)[0]
            */
            
            let selectedEventItem: Event!
            
            if resultSearchController.active {
                selectedEventItem = filteredEventList[self.tableView.indexPathForSelectedRow!.row] as Event
                resultSearchController.active = false
            } else {
                selectedEventItem = eventList[self.tableView.indexPathForSelectedRow!.row] as Event
            }
            
            destination!.selectedEventItem = eventAPI.getById(selectedEventItem.eventId)[0] //option 2
            
            destination!.title = "Edit event"
        } else if segue.identifier == Constants.SegueIds.editEventItem {
            destination!.title = "Add event"
        }
        
        
    }
    
    // MARK: - Table edit mode
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete item from datastore
            eventAPI.deleteItem(eventList[indexPath.row])
            //Delete item from tableview datascource
            eventList.removeAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.title = String(format: "Upcoming events (%i)",eventList.count)
        }
    }
    
    // MARK: - Search
    
    /**
    Calls the filter function to filter results by searchbar input
    */
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterEventListContent(searchController.searchBar.text!)
        refreshTableData()
    }
    
    // MARK - Utility functions
    
    /**
    Create a searchbar, bind it to tableview header
    */
    private func initResultSearchController() {
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = resultSearchController.searchBar
    }
    
    /**
    Create filter predicates to filter events on title, venue, city, data
    
    :params: term to search
    */
    private func filterEventListContent(searchTerm: String) {
        //Clean up filtered list
        filteredEventList.removeAll(keepCapacity: false)
        
        //Create a collection of predicates,
        //search items by: title OR venue OR city
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "\(Constants.EventAttributes.title.rawValue) contains[c] %@", searchTerm.lowercaseString))
        predicates.append(NSPredicate(format: "\(Constants.EventAttributes.venue.rawValue) contains[c] %@", searchTerm.lowercaseString))
        predicates.append(NSPredicate(format: "\(Constants.EventAttributes.city.rawValue)  contains[c] %@", searchTerm.lowercaseString))

        //TODO add datePredicate
        
        //Create compounded OR perdicate
        let compoundPredicate = NSCompoundPredicate.orPredicateWithSubpredicates(predicates)
        
        //Filter results with compound predicate by closing over the inline variable
        filteredEventList =  eventList.filter {compoundPredicate.evaluateWithObject($0)}
    }
    
    func updateEventTableData(notification: NSNotification) {
        print("Reading in data...")
        refreshTableData()
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func setStateLoading(notification: NSNotification) {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
    }
    
    
    /**
    Refresh table data
    */
    private func refreshTableData(){
            self.eventList.removeAll(keepCapacity: false)
            self.eventList = self.eventAPI.getSortedByDateInRange()
            self.tableView.reloadData()
            self.title = String(format: "Upcoming events (%i)",self.eventList.count)
    }
    
    /**
    Get a date as formatted String
    */
    private func getFormattedDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM\nyyyy"
        let DateInFormat = dateFormatter.stringFromDate(date)
        
        return DateInFormat
    }
    
    /**
    Retrieve image from remote or cache.
    */
    private func getEventImage(indexPath: NSIndexPath) -> UIImage {
        //TODO
        
        //Check if local image is cached, if not use GCD to download and display it.
        //Use indexPath as reference to cell to be updated.
        
        //For now load from image assets locally.
        return UIImage(named: Constants.EventCovers.getAll[0])!
    }
    
}


