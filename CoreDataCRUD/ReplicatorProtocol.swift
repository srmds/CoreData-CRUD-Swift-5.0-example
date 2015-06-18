//
//  ReplicatorProtocol.swift
//  CoreDataCRUD
//  Written by Steven R.
//

import Foundation

protocol ReplicatorProtocol {
    
    // protocol definition goes here
    
    func pull() -> Bool
    
    func processData() -> Bool
}