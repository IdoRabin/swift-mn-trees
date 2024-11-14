//
//  MNNodeEdgeProtocol.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

public protocol MNNodeEdgeProtocol<NodeType> : Sendable, Hashable, Codable, CustomStringConvertible {
    associatedtype NodeType = MNNodeProtocol
    
    var from : Self { get }
    var to : Self { get }
    var type : MNEdgeType { get }
}

public extension MNNodeEdgeProtocol /* default implementations */ {
    
    var description: String {
        return "\(from) (\(type)-> \(to)"
    }
}
