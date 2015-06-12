# CoreData-CRUD-Swift-iOS-example [![Join the chat at https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


A (very simple) example project that exposes the usage of Core Data to create Entities and to Persist to a SQLite Datastore

## The objective

for this project is to learn (for now mostly myself ;D )  two things:

- Learning the Apple Swift language
- Learning to use Core Data to create Entities and to persist Entities to a SQLite datastore.

## Contribution

Do you have questions or want to help? Enhancements and/or fixes and suggestions are welcome! Just drop a line via gitter of create issues and/or pull requests.


## Apple Swift Version

For this project the Apple Swift `version 1.2` is used. To check which version of swift is installed, via terminal:

	$  xcrun swift --version

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
The AnyObjects type is this example are [non-standard persistent attributes](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdNSAttributes.html) just attributes that are not support directly in Core Data.
The AnyObject, as the name suggests can therefore be for example an `Array` or `NSURL` or any other object type.

## Entity Manager 
 
The [EventManager](https://github.com/srmds/CoreData-CRUD-Swift-iOS-example/blob/master/CoreDataCRUD/EventManager.swift) is a manager that allows CRUD operations on the persistence store with an Event entity.

Currently it exposes the following functions:

* Creates a new Managed object and persists to datastore.

* Retrieves all event items stored in the persistence layer.

* Retrieve an event found by it's stored id.

* Retrieves all event items stored in the persistence layer and sort it by Date.

* Delete all items of Entity: Event, from persistence layer.

	


