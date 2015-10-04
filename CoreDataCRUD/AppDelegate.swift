//
//  AppDelegate.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 17/06/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var eventAPI: EventAPI!
    private var localReplicator: LocalReplicator!
    private let runCountNamespace = "runCount"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.enableDebugMode(true)
        self.eventAPI = EventAPI.sharedInstance
        self.localReplicator = LocalReplicator.sharedInstance
        self.handleRunCount()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {}

    func applicationWillTerminate(application: UIApplication) {}

    func sharedInstance() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    lazy var datastoreCoordinator: DatastoreCoordinator = {
        return DatastoreCoordinator()
    }()
    
    lazy var contextManager: ContextManager = {
        return ContextManager()
    }()
    
    private func enableDebugMode(shouldLog:Bool) {
        if shouldLog {
            //Debug - location of sqlite db file
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            print("Debug - location of sqlite db file:\n\(paths[0])\n")
        }
    }
    
    private func handleRunCount(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Store a finger to runCount, not that complex, nothing to worry about.
        if var runCount:Int = defaults.integerForKey(runCountNamespace) {
            if(runCount == 0){
                print("First time app run, therefore importing event data from local source...")
                localReplicator.fetchData()
            }
            
            runCount += 1
            defaults.setObject(runCount, forKey:runCountNamespace)
            print("current runCount: \(runCount)")
        }
    }

}

