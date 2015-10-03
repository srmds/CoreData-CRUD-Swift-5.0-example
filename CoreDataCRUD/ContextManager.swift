//
//  ContextManager.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 30/09/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation
import CoreData

/**
    The Context Manager that will manage the merging of child contexts with Master ManagedObjectContext
*/
class ContextManager: NSObject {
    
    let datastore:DatastoreCoordinator!
    
    override init() {
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        self.datastore = appDelegate.datastoreCoordinator
        super.init()
    }
    
    lazy var masterManagedObjectContextInstance: NSManagedObjectContext = {
        var masterManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        masterManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator
        
        return masterManagedObjectContext
    }()
    
    lazy var mainManagedObjectContextInstance: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator
        
        return mainManagedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
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
    
    private func mergeChangesFromMainContext() {
        dispatch_async(dispatch_get_main_queue(),{
            do {
                try self.mainManagedObjectContextInstance.save()
            }  catch let mocSaveError as NSError {
                print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
            }
        })
    }
    
}