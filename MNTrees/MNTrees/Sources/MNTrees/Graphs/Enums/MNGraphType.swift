//
//  MNGraphType.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

// TODO: which is best for Graph types: describing a concrete type exactly? of GraphCapabilitiess? or OptionSet of grpah descriptor / charachteristics?
public enum MNGraphType: String, CaseIterable {
    
    case anyGraph
    case tree
    
    var edgeType : MNEdgeType {
        switch self {
        case .anyGraph:
            return .bidi
        case .tree:
            return .to
        }
    }
}
