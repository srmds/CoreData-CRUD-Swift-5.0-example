//
//  ReplicatorProtocol.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 04/10/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation

//Methods that must be implemented by every class that extends it.
protocol ReplicatorProtocol {
    func fetchData()
    func processData(jsonResult: AnyObject?)
}