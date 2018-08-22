# CoreData-CRUD-Swift-iOS-example [![Join the chat at https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/srmds/CoreData-CRUD-Swift-iOS-example?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[Swift 4.1](https://swift.org) - A (very simple) example project that exposes the usage of CoreData to create entities and to persist to a SQLite Datastore.

This app demonstrates Core Data and persistent storage, by reading Event data from both, locally and remotely retrieved [JSON file /  response](https://github.com/jongensvantechniek/CoreData-CRUD-Swift-3.1-example/blob/master/CoreDataCRUD/events.json), creates and stores those Events in a SQLite datastore. It is possible to do single and batch updates, deletions, retrieving and filtering on stored Events.

![screenshotOverview](http://i.imgur.com/YZxz2Km.jpg)

## Prerequisites

* [Xcode 9.3+ - Swift 4.1](https://developer.apple.com/xcode/downloads/)
* [iOS 9.3+ / iOS10 / iOS11](https://developer.apple.com/xcode/downloads/)
* [SQLite browser](https://sqlitebrowser.org)

### iOS

Tested on:

- iOS9.3 
- iOS10
- iOS11.4.1

### iPhone

Tested on:

- iPhone 6
- iPhone 6s
- iPhone 7
- iPhone 8

## The objective

for this project is to learn to:

- Use Core Data to create Entities and to persist Entities to a SQLite datastore

- Help others understand and use Core Data with simple, yet concrete examples,
  on the usage of Core Data and persistent store

### location of SQLite database

In order to inspect persisted events you can use for example a SQLite database browser to view persisted entries: https://sqlitebrowser.org

The actual path of the SQLite database file will be shown in the Xcode console logger. For example:

`/Users/<name>/Library/Developer/CoreSimulator/Devices/<device-uuid>/data/Containers/Data/Application/<application-uuid>/Documents`

Select and copy the above path of the SQLite databasefile, go to MacOS Finder, click:
`SHIFT + CMD + G` and paste path and click: `OK` and finally open the SQLite database file with, for example: [SQLite browser](https://sqlitebrowser.org)

Note: this example project is non-exhaustive.

## Contributions

Do you have questions or want to help? Enhancements and/or fixes and suggestions are welcome! Just drop a line via gitter of create issues and/or pull requests.

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

The AnyObject type in this example are [non-standard persistent attributes](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/LifeofaManagedObject.html) that are not supported directly in Core Data. The AnyObject, as the name suggests, can therefore be for example: an `Array` or `NSURL`, or any other objecttype.

### [Core Data API](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075-CH2-SW1)

This application utilizes the Core Data stack concurrently
to locally persist data. Below an overview of how the Core Data stack is implemented and utilized within the application.

![CoreData Thread confinement](http://i.imgur.com/vm74cWf.jpg)

#### Thread confinement

You can see that there are three layers used, this is to provide true concurrency and also utilize thread confinement.

The `minions* workers` are the workers in the `EventAPI` that save each `parsed` and prepared `NSManagedObject` within it's own Thread. Eventually when all NSManagedObjects are stored within the thread confined context, the `EventAPI` calls the `MainContext` via the `PersistenceManager`, which in turn will call `ContextManager` and cause the `minions` to merge / synchronize with the MainContext and finally with the `Master application context`, which finally calls the `DataStore Coordinator` to actually store the NSManagedObjects to the datastore.

More info on [concurrency](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/Concurrency.html#//apple_ref/doc/uid/TP40001075-CH24-SW1)

#### Event API

The [Event API](https://github.com/jongensvantechniek/CoreData-CRUD-Swift-3.1-example/blob/master/CoreDataCRUD/EventAPI.swift)
is the interface where a viewcontroller directly communicates to. The Event API exposes several endpoints to a Viewcontroller to Create, Read, Update, Delete Events.

Open up Xcode, and open the project, and open the `EventAPI.swift` file.
Then click on `^6`, thus `control + 6`, this will open up an overview of several CRUD methods used, and click on the method of interest, to see it's implementation.

![](http://i.imgur.com/IItWYVW.png)

*No copyright infringement intended.

### More info
More Core Data basics can be found [here](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreData/Concurrency.html#//apple_ref/doc/uid/TP40001075-CH24-SW1)


## TODO

- Make step by step guide from scratch to working prototype.


### The MIT License (MIT)

Copyright (c) 2016 - Jongens van Techniek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
