//
//  MNTree.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

public typealias MNTreeName = MNGraphName

public enum MNTreeType: String, CaseIterable {
    // N-Nodes branching
    case NAryTree // N-ary tree, no balancing
    case KAryTree // K-ary tree, search tree for (ususally) decomposed strings, no balancing
    
    // Binary branching
    case BinaryTree // binary search tree, no balancing
    case BTree // self-balancing search tree optimized for DBs
    case AVLTree // self-balancing binary search tree
}

public protocol MNTreeConfig : MNGraphConfig {
    var treeType : MNTreeType { get set }
}

public protocol MNTree : MNGraph {
    
    var config : any MNTreeConfig { get set }
    var treeKind : MNTreeType { get }
    
    // How to specialize an existing init or hide the super.init from the user (dev)?
    init(name: MNTreeName, config: any MNTreeConfig)
}

public extension MNTree {
    var treeKind : MNTreeType {
        return config.treeType
    }
}

