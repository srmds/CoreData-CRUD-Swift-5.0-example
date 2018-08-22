//
//  AppDelegate.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var eventAPI: EventAPI!
    fileprivate var localReplicator: LocalReplicator!
    fileprivate let runCountNamespace = "runCount"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.enableDebugMode(true)
        self.eventAPI = EventAPI.sharedInstance
        self.localReplicator = LocalReplicator.sharedInstance
        self.handleRunCount()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

    func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    lazy var datastoreCoordinator: DatastoreCoordinator = {
        return DatastoreCoordinator()
    }()

    lazy var contextManager: ContextManager = {
        return ContextManager()
    }()

    fileprivate func enableDebugMode(_ shouldLog: Bool) {
        if shouldLog {
            //Debug - location of sqlite db file
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            print("Debug - Make sure to have a SQLite database viewer installed on MacOS, for example: https://sqlitebrowser.org")
            print("Debug - location of SQLite database file:\n\n\(paths[0])\n")
            print("Debug - Select and copy the above path of the SQLite databasefile, go to MacOS Finder, click:\n\nSHIFT + CMD + G\n\nand paste path and click: OK and open the (SingleViewCoreData.sql) SQlite file with, for example: SQLite browser\n")
        }
    }

    fileprivate func handleRunCount() {
        let defaults = UserDefaults.standard

        //Store a finger to runCount, not that complex, nothing to worry about.
        var runCount: Int = defaults.integer(forKey: runCountNamespace)

        if(runCount == 0) {
            print("First time app run, therefore importing event data from local source...")
            localReplicator.fetchData()
        }

        runCount += 1
        defaults.set(runCount, forKey:runCountNamespace)
        print("current runCount: \(runCount)")
    }

}
