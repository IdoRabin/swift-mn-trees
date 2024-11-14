//
//  MNTrees.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation
import MNUtils
@preconcurrency import DSLogger

// Logger
fileprivate let dlog : DSLogger? = DLog.forClass("MNTrees")?.setting(verbose: false)

/// A container for various trees, of heterogenic generic-data types
public class MNTrees : MNGraphs {
    
    var MAX_TREE_DEPTH : MNTreeNodeDepth {
        return Self.MAX_TREE_DEPTH
    }

    static var MAX_TREE_DEPTH : MNTreeNodeDepth {
        return 128
    }

    // MARK: Singleton
//    private static let _shared = MNTrees()
//    public static func shared<T:Any>(_ block: (_ tree:MNTrees)->T)->T {
//        return _shared
//    }
    
    override init(name:String? = nil) {
        super.init(name: name ?? "MNTrees")
    }

    
    // MARK: Private
    // MARK: Public
    
    // MARK: Graph Management - getting / searching for trees
    func treesByIds<ID:MNNodeIDable>(_ ids:[ID])->[ID:[any MNTree]] {
        return graphsByIds(ids).mapValues { $0.compactMap { $0 as? any MNTree } }
    }
    
    func treesByNames(_ names:[MNGraphName])->[MNGraphName:[any MNTree]] {
        return graphsByNames(names).mapValues { $0.compactMap { $0 as? any MNTree } }
    }
    
    func firstTreeById<ID:MNNodeIDable>(_ id:ID)->(any MNTree)? {
        return treesByIds([id])[id]?.first
    }
    
    func firstTreeByName(_ name:MNGraphName)->(any MNTree)? {
        return treesByNames([name])[name]?.first
    }
    
    
}
