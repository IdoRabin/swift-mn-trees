//
//  MNTreeNodeType.swift
//  MNTree
//
//  Created by ido on 24/10/2024.
//

// import Foundation

public enum MNTreeNodeType : String, Codable, CaseIterable, CustomStringConvertible {
    case leaf
    case root
    case branch
    
    var treeStructDescStr : String {
        switch self {
        case .root: return "+"
        case .branch: return "-"
        case .leaf: return "^"
        }
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .leaf: return ".leaf"
        case .root: return ".root"
        case .branch: return ".branch"
        }
    }
}
