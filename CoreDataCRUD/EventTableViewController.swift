//
//  EventTableViewController.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import UIKit

class EventTableViewController: UITableViewController {

    var eventList:Array<Event> = []
    var selectedEventItem : Event!
    
    //placeholder for event endpoint
    var eventAPI: EventAPI!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        self.eventAPI = EventAPI.sharedInstance
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
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
        
        eventList = eventAPI.getAll()
        
        //use GCD to get updates for the data, make asynchronous call
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let eventCell =
            tableView.dequeueReusableCellWithIdentifier(Constants.CellIds.EventTableCell, forIndexPath: indexPath) as! EventTableViewCell

        let eventItem = eventList[indexPath.row]
        
        eventCell.eventDateLabel.text = getFormattedDate(eventItem.date)
        eventCell.eventTitleLabel.text = eventItem.title
        eventCell.eventLocationLabel.text = "\(eventItem.venue) - \(eventItem.city)"
        
        return eventCell
    }
    
    private func getFormattedDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM\nyyyy"
        let DateInFormat = dateFormatter.stringFromDate(date)
            
        return DateInFormat
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
}
