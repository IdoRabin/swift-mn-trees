//
//  MNGraphs.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

typealias AnyMNGraph = any MNGraph

public class MNGraphs {
    
    var MAX_RECURSION_DEPTH : MNNodeRecursionDepth {
        return Self.MAX_RECURSION_DEPTH
    }
    
    static var MAX_RECURSION_DEPTH : MNNodeRecursionDepth {
        return 1024
    }
    
    private let queue : DispatchQueue
    private var graphs : [MNKindKey:[String /* graph Id as string */ :AnyMNGraph]] = [:]
    
    // MARK: Singleton
//    private static let _shared = MNTrees()
//    public static func shared<T:Any>(_ block: (_ tree:MNTrees)->T)->T {
//        return _shared
//    }
    
    init(name:String? = nil) {
        queue = DispatchQueue(label: "com.MNTrees.\(name ?? "MNGraphs")", attributes: .concurrent)
    }
    
    
    // MARK: Private
    // MARK: Public
    
    // MARK: Graph Management - getting / searching for graphs
    
    func graphsOfKind(_ kind:MNKindKey)->[AnyMNGraph] {
        return queue.sync {
            return graphs[kind]?.values.compactMap { $0 } ?? []
        }
    }
    
    /// Returns all graphs with the given ids, by a specific kind, or (if not provided) all kinds of graphs.
    /// - Parameters:
    ///   - ids: ids of graphs to search for
    ///   - kind: (optional) the kind of the graphs to return (Kind is a string describing the class and generic types of the Graph)
    /// - Returns:dictionary of ids to graphs. We have an array of graphs for each id, since we can have multiple graphs with the same id, but of different kinds.
    func graphsByIds<ID:MNNodeIDable>(_ ids:[ID], kind:MNKindKey? = nil)->[ID:[AnyMNGraph]] {
        return queue.sync {
            var result : [ID:[AnyMNGraph]] = [:]
            let kinds = (kind != nil) ? [kind!] : self.graphs.keysArray
            for (kindKey, graphOfKind) in graphs {
                if kinds.contains(kindKey) {
                    for (k, v) in graphOfKind {
                        if let id = k as? ID, ids.contains(id) {
                            result[id] = result[id] ?? [v]
                        }
                    }
                }
            }
            
            return result
        }
    }
    
    
    /// Returns all graphs with the given names, by a specific kind, or (if not provided) all kinds of graphs.
    /// - Parameters:
    ///   - names: names of graphs to search for
    ///   - kind: (optional) the kind of the graphs to return (Kind is a string describing the class and generic types of the Graph)
    /// - Returns: dictionary of names to graphs. We have an array of graphs for each name, since we can have multiple graphs with the same name, but of different kinds.
    func graphsByNames(_ names:[MNGraphName], kind:MNKindKey? = nil)->[MNGraphName:[AnyMNGraph]] {
        return queue.sync {
            var result : [MNGraphName:[AnyMNGraph]] = [:]
            let kinds = (kind != nil) ? [kind!] : self.graphs.keysArray
            for (kindKey, graphOfKind) in graphs {
                if kinds.contains(kindKey) {
                    // private var graphs : [MNKindKey:[String /* graph Id as string */ :AnyMNGraph]] = [:]
                    for (_ /* graph Id as string */, anMNGraph) in graphOfKind {
                        if anMNGraph.name != nil, let aname = anMNGraph.name, names.contains(aname) {
                            result[aname] = result[aname] ?? [anMNGraph]
                        }
                    }
                }
            }
            
            return result
        }
    }
    
    func firstGraphById<ID:MNNodeIDable>(_ id:ID, kind:MNKindKey? = nil)->AnyMNGraph? {
        return graphsByIds([id])[id]?.first
    }
    
    func firstGraphByName(_ name:MNGraphName, kind:MNKindKey? = nil)->AnyMNGraph? {
        return graphsByNames([name])[name]?.first
    }
}
