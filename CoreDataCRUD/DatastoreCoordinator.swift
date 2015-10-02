//
//  DatastoreCoordinator.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 30/09/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//
import Foundation
import CoreData

/**
    Core Data persistenceStore coordinator that will for example create the SQlite database.
*/
class DatastoreCoordinator: NSObject {
    
    private let objectModelName = "CoreDataCRUD"
    private let objectModelExtension = "momd"
    private let dbFilename = "SingleViewCoreData.sqlite"
    private let appDomain = "com.io-pandacode.CoreDataCRUD"
    
    override init() {
        super.init()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file.
        // This code uses a directory named "com.srmds.<dbName>" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        return urls[urls.count-1]
    }()
    
    //
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional.
        // It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(self.objectModelName, withExtension: self.objectModelExtension)!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    //
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // The persistent store coordinator for the application. This implementation creates and return a coordinator,
        // having added the store for the application to it. This property is optional since there are legitimate error
        // conditions that could cause the creation of the store to fail.
        
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.dbFilename)
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: self.appDomain, code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            abort()
        }
        
        return coordinator
    }()
}