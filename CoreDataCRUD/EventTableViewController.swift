//
//  EventTableViewController.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import UIKit

class EventTableViewController: UITableViewController, UISearchResultsUpdating {

    var eventList:Array<Event> = []
    var filteredEventList:Array<Event> = []
    var selectedEventItem : Event!
    var resultSearchController:UISearchController!
    
    //placeholder for event endpoint
    var eventAPI: EventAPI!

    override func viewDidLoad() {
        super.viewDidLoad()
        initResultSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.eventAPI = EventAPI.sharedInstance

        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Store a finger to runCount, not that complex, nothing to worry about.
        if var runCount:Int = defaults.integerForKey(Constants.UserDefaults.RunCount) {
            if(runCount == 0){
                print("First time app run, therefore creating some test data...")
                if eventAPI.createAndPersistTestData() {
                    var outputText :String!
                    outputText = "Successfully created test items."
                    print(outputText)
                }
            }
            
            runCount = runCount+1
            print("current runCount: \(runCount)")
            
            defaults.setObject(runCount, forKey:Constants.UserDefaults.RunCount)
        }
        
        self.eventList = eventAPI.getAll()
        refreshTableData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
        eventCell.eventLocationLabel.text = "\(eventItem.venue) - \(eventItem.city)"
        
        return eventCell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? EventItemViewController
        
        if segue.identifier == Constants.SegueIds.showEventItem {
            destination!.selectedEventItem = eventList[self.tableView.indexPathForSelectedRow!.row] as Event
            destination!.title = "Edit event"
        } else {
            destination!.title = "Add event"
        }
    }
    
    // MARK: - Table edit mode
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete item from datastore
            eventAPI.deleteItem(eventList[indexPath.row])
            //Delete item from tableview datascource
            eventList.removeAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
    
    /**
        use GCD to get updates for the data, make asynchronous call
    */
    private func refreshTableData(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
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
    
}


