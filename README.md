# CoreData-CRUD-Swift-iOS-example [![Join the chat at https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Swift 2.0 - A (very simple) example project that exposes the usage of CoreData to create entities and to persist to a SQLite Datastore.

This app demonstrates Core Data and persistent storage, by reading Event data from a [JSON file /  response](https://github.com/srmds/CoreData-CRUD-Swift-2.0-example/blob/master/CoreDataCRUD/events.json), creates and stores those Events in a SQLite datastore. It is possible to do single and batch updates, deletions, retrieving and filtering on stored Events.

![screenshotOverview](http://i.imgur.com/YZxz2Km.jpg)

## Prerequisites

* [Xcode 7.0+](https://developer.apple.com/xcode/downloads/)
* [iOS9](https://developer.apple.com/xcode/downloads/)

Tested with iPhone 6.

## The objective

for this project is to learn (for now mostly myself ;D ) to:

- use Core Data to create Entities and to persist Entities to a SQLite datastore.

- help others understand and use Core Data with simple, yet concrete examples, on the usage of Core Data and persistent
  store.

Note that this example project is non-exhaustive and since i'm still learning (more) about the Core Data framework,
any progress on my part will be reflected in this project as updates to it.


## Contributions

Do you have questions or want to help? Enhancements and/or fixes and suggestions are welcome! Just drop a line via gitter of create issues and/or pull requests.

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

The AnyObject type in this example are [non-standard persistent attributes](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/LifeofaManagedObject.html) that are not support directly in Core Data. The AnyObject, as the name suggests, can therefore be for example an: `Array` or `NSURL`, or any other object type.

### [Core Data API](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075-CH2-SW1)

This application utilizes the Core Data stack concurrently
to locally persist data. Below an overview of how the Core Data stack is implemented and utilized within the application.

![CoreData Thread confinement](http://i.imgur.com/vm74cWf.jpg)

#### Thread confinement

You can see that there are three layers used, this is to provide true concurrency and also utilize thread confinement.

The `minions* workers` are the workers in the `EventAPI` that save each `parsed` and prepared `NSManagedObject` within it's own Thread. Eventually when all NSManagedObjects are stored within the thread confined context, the `EventAPI` calls the `MainContext` via the `PersistenceManager`, which in turn will call `ContextManager` and cause the `minions` to merge / synchronize with the MainContext and finally with the `Master application context`, which finally calls the `DataStore Coordinator` to actually store the NSManagedObjects to the datastore.

More info on [concurrency](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/Concurrency.html#//apple_ref/doc/uid/TP40001075-CH24-SW1)

#### Event API

The [Event API](https://github.com/srmds/CoreData-CRUD-Swift-2.0-example/blob/master/CoreDataCRUD/EventAPI.swift)
is the interface where a view controller directly communicates to. The Event API exposes several endpoints to a View controller to create, read, update, delete Events.

Open up Xcode, and open the project, and open the `EventAPI.swift` file.
Then click on `^ 6`, thus `control + 6`, this will open up an overview of several CRUD methods used, and click on the method of interest, to see it's implementation.

*No copyright infringement intended.

### More info
More Core Data basics can be found [here](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/Concurrency.html#//apple_ref/doc/uid/TP40001075-CH24-SW1)


## TODO

- Get a better understanding of relationships, no pun intended, both in real-life and in Core Data.

- Make step by step guide from scratch to working prototype.
