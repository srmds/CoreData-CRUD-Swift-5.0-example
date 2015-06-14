# CoreData-CRUD-Swift-iOS-example [![Join the chat at https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


Swift 2.0 - A (very simple) example project that exposes the usage of CoreData to create entities and to persist to a SQLite Datastore

![screenshotOverview](http://i.imgur.com/zPV4hKW.png)
## The objective

for this project is to learn (for now mostly myself ;D ) to:

- use Core Data to create Entities and to persist Entities to a SQLite datastore.

- help others understand and use Core Data with simple, yet concrete examples, on the usage of Core Data and persistent
  store.
  
Note that this example project is non-exhaustive and since i'm still learning (more) about the Core Data framework,
any progress on my part will be reflected in this project as updates to it. 


## Contributions

Do you have questions or want to help? Enhancements and/or fixes and suggestions are welcome! Just drop a line via gitter of create issues and/or pull requests.


## Versions

## iOS

The version used in this project is `version 9.0`

### Swift

For this project the Apple Swift `version 2.0` is used. 

### Xcode	

This project is build with Xcode `version 7.0 beta`.

## Overview /utilities

In this project the usage of pragmas will help you through the code exploration. For example:

Open up Xcode, and open the project, and open the `PersistenceManager.swift` file.
Then click on `^ 6`, thus `control + 6`, this will open up an overview of several CRUD methods used.
And click on the method of interest, to see it's implementation.

![](http://i.imgur.com/IItWYVW.png)

## Model

A model represents the entity that can be used to store in the datastore.
The [Event](https://github.com/srmds/CoreData-CRUD-Swift-iOS-example/blob/master/CoreDataCRUD/Event.swift) Entity/ Model has the following model attributes:

	class Event: NSManagedObject {
	
	    @NSManaged var title: String
	    @NSManaged var date: NSDate
	    @NSManaged var venue: String
	    @NSManaged var city: String
	    @NSManaged var country: String
	    @NSManaged var attendees: AnyObject
	    @NSManaged var fb_url: AnyObject
	    @NSManaged var ticket_url: AnyObject
	    @NSManaged var eventId: String
	
	}
	
The AnyObject type in this example are [non-standard persistent attributes](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdNSAttributes.html) attributes that are not support directly in Core Data. The AnyObject, as the name suggests, can therefore be for example an: `Array` or `NSURL`, or any other object type.

## Persistence Manager 
 
The [Persistence Manager](https://github.com/srmds/CoreData-CRUD-Swift-2.0-example/blob/master/CoreDataCRUD/PersistenceManager.swift) is a manager that allows `CRUD` operations on the persistence store with an Event entity.

Currently it exposes the following functions:

**Create**

* Creates a new Managed object and persists to datastore.

**Read**

* Retrieves all event items stored in the persistence layer.

* Retrieve an event found by it's stored id.

* Retrieves all event items stored in the persistence layer and sort it by Date.

**Update**

*  Update all events (batch update) attendees list.

**Delete**

* Delete all items of Entity: Event, from persistence layer.

	
## TODO

Get a better understanding of relationships, no pun intended, both in real-life and in Core Data.

