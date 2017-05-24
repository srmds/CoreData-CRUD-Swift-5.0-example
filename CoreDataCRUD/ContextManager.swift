//
//  ContextManager.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import Foundation
import CoreData

/**
    The Context Manager that will manage the merging of child contexts with Master ManagedObjectContext
*/
class ContextManager: NSObject {

    let datastore: DatastoreCoordinator!

    override init() {
        let appDelegate: AppDelegate = AppDelegate().sharedInstance()
        self.datastore = appDelegate.datastoreCoordinator
        super.init()
    }

    // Create master context reference, with PrivateQueueConcurrency Type.
    lazy var masterManagedObjectContextInstance: NSManagedObjectContext = {
        var masterManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator

        return masterManagedObjectContext
    }()

    //Create main context reference, with MainQueueuConcurrency Type.
    lazy var mainManagedObjectContextInstance: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator

        return mainManagedObjectContext
    }()

    // MARK: - Core Data Saving support

    /**
        Saves changes from the Main Context to the Master Managed Object Context.
    
        - Returns: Void
    */
    func saveContext() {
        defer {
            do {
                try masterManagedObjectContextInstance.save()
            } catch let masterMocSaveError as NSError {
                print("Master Managed Object Context save error: \(masterMocSaveError.localizedDescription)")
            } catch {
                print("Master Managed Object Context save error.")
            }
        }

        if mainManagedObjectContextInstance.hasChanges {
            mergeChangesFromMainContext()
        }
    }

    /**
        Merge Changes on the Main Context to the Master Context.
    
        - Returns: Void
    */
    fileprivate func mergeChangesFromMainContext() {
        DispatchQueue.main.async(execute: {
            do {
                try self.mainManagedObjectContextInstance.save()
            } catch let mocSaveError as NSError {
                print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
            }
        })
    }

}
