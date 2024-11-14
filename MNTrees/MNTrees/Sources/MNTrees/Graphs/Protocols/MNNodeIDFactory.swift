//
//  MNNodeIDFactory.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation


/// Capability protocol for a Node ID factory
public protocol MNNodeIDFactoryCaps {
    var isUsesSeed : Bool { get }
    var isResettable : Bool { get }
}

/// A factory for creating new IDs for nodes (generic)
/// - Parameter ID: The type of ID to create
/// - can be used with a seed and counter to create repeatable unique IDs
public protocol MNNodeIDFactory<ID> : MNNodeIDFactoryCaps {
    associatedtype ID : MNNodeIDable
    
    func makeID()->ID
    func reset(seed newSee:UInt64, counter newCounter:UInt64)
    var count : UInt64 { get }
    var seed : UInt64 { get }
    
    init(seed:UInt64?)
}
