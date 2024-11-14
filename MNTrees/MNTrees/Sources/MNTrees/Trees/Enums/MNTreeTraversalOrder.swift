//
//  MNTreeTraversalOrder.swift
//  MNTree
//
//  Created by ido on 22/10/2024.
//

// import Foundation

public enum MNTreeTraversalOrder : CaseIterable, CustomStringConvertible {
    /// Will iterate breadth first
    case breadthFirst

    /// Will iterate depth first
    case depthFirst

    /// Will iterate uptree using depth first in this order: root, parent
    case upTree
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .breadthFirst:
            return ".breadthFirst"
        case .depthFirst:
            return ".depthFirst"
        case .upTree:
            return ".upTree"
        }
    }
}
