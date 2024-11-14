//
//  MNNode.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

public typealias MNNodeValueable = Hashable & Sendable
public typealias MNNodeIDable = Hashable & Sendable & RawRepresentable<String> // TODO: determine & RawRepresentable or CustomStringConvertible
public typealias MNNodeRecursionDepth = Int
public typealias MNKindKey = String

// A mechanism to pass new IDS to a node in various ways
public enum MNNodeNewID<ID> {
    typealias ID = MNNodeIDable
    
    /// Uses the value.id for the new node, assuming MNNode.value is MNNode or Identifiable
    case useValueID
    
    /// Uses the associated id value as the new ID
    case id(ID)
    
    /// Uses an id factory to generate a new id
    case factory(factory:any MNNodeIDFactory<ID>)
}

// A class for a generic node
public protocol MNNodeProtocol<ID, Value> : Sendable, Hashable {
    
    associatedtype ID : MNNodeIDable
    associatedtype Value : MNNodeValueable
    
    /// The id for this node - May (or may not) be related to the Value type. When Value conforms to Identifiable, this is the same as value.id.
    var id : ID { get set }
    
    /// The value that this node holds
    var value : Value? { get set }
    
    // TBD: var edges : [MNEdgeType:[Self]] { get set }
    
    // Returns all the edges "eminating" from this node
    // func nodeEdges(byType:MNEdgeType)->[Self]
    
    /// "required" init with the id and value for this node
    /// - Parameters:
    ///   - id: id for the new node
    ///   - value: (optional) value for the new node
    init(id:MNNodeNewID<ID>, value:Value?)
    
    /// A string describing the flavour, or kind of the whole homogeneous graph vis-a-vie its implementor and generic components. Can be used as an indexing key (foreign key?)
    var graphKindKey : MNKindKey { get }
}

public extension MNNodeProtocol /* default implementations */ {
    
    var graphKindKey : MNKindKey {
        return "\(Self.self)"
    }
}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension MNNodeProtocol where Value : Identifiable, Value.ID == ID {
    
    var id :  ID {
        get {
            return value!.id
        }
        set {
            let msg = "❌ MNNodeProtocol where ID : Identifiable cannot set a new ID. To change the id, set a new value with the wanted id instead."
            print(msg)
            fatalError(msg)
        }
    }
}

