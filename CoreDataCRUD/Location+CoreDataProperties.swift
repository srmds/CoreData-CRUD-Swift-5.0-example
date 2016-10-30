//
//  Location+CoreDataProperties.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 13/07/16.
//  Copyright © 2016 io pandacode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var locationId: String?
    @NSManaged var address: String?

}
