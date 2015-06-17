//
//  BatchActionsViewController.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import UIKit

class BatchActionsViewController: UIViewController {

    private var eventAPI: EventAPI!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.eventAPI = EventAPI.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func anonimizeListButtonTapped(sender: AnyObject) {
        eventAPI.updateAllEventAttendees()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func deleteAllEventsButtonTapped(sender: AnyObject) {
        eventAPI.deleteAll()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func restoreEventsButtonTapped(sender: AnyObject) {
        eventAPI.createAndPersistTestData()
          self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
