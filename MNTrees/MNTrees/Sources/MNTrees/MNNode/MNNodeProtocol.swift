//
//  MNNode.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

public typealias MNNodeValueable = Hashable & Codable
public typealias MNNodeIDable = Hashable & Codable

// A class for a generic node
public protocol MNNodeProtocol<ID, Value> : Codable {
    
    associatedtype ID : MNNodeIDable
    associatedtype Value : MNNodeValueable
    
    var id : ID { get set }
    var value : Value { get set }
    // var edges : [MNEdgeType:[Self]] { get set }
    
    func nodeEdges(byType:MNEdgeType)->[Self]
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension MNNodeProtocol where Value : Identifiable, Value.ID == ID {
    
    var id :  ID {
        get {
            return value.id
        }
        set {
            print("MNNodeProtocol where ID : Identifiable cannot set a new ID")
            // Does nothing!
        }
    }
}

