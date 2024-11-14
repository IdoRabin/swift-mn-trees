//
//  MNTreeNodeProtocol+Array.swift
//  MNTree
//
//  Created by ido on 30/10/2024.
//

extension Array where Element : MNTreeNodeProtocol {
    
    /// Returns all the ids of the nodes in the array, by the order of the array.
    /// NOTE: if two (or more) nodes in the array share the same id, duplicate ids in the result may appear. This is, of course if the ID is not uniquely generated for each node.
    var ids : [Element.ID] {
        return self.map { $0.id }
    }
    
    /// Returns all parants of the nodes in the array, by the order of the array.
    /// NOTE: if two (or more) nodes in the array share the same parent, duplicate parents in the result may appear.
    var parents : [Element] {
        // NOTE: Element is assumed to be equal to Element.NodeType
        return self.compactMap { $0.parent }
    }
    
    /// Returns all the values of the nodes in the array, by the order of the array.
    /// NOTE: if two (or more) nodes in the array share the same value, duplicate values in the result may appear.
    var values : [Element.Value] {
        return self.compactMap { $0.value }
    }
    
    
    /// Returns all the roots of the nodes in the array, by the order of the array.
    /// NOTE: May be computationally expensive. if two (or more) nodes in the array have the same root, duplicate roots in the result may appear.
    var roots : [Element] {
        return self.compactMap { node in
            node.root
        }
    }
    
    /// Returns the ids of the nodes in the array, filtered by the given closure, in the order of the array.
    func ids(filteredBy:(_ id:Element.ID)->Bool)->[Element.ID] {
        return self.ids.filter(filteredBy)
    }
    
    /// Returns the values of the nodes in the array, filtered by the given closure, in the order of the array.
    func values(filteredBy:(_ value:Element.Value)->Bool)->[Element.Value] {
        return self.values.filter(filteredBy)
    }
    
    var asDictByDepth: [MNTreeNodeDepth:[Element]] {
        var result : [MNTreeNodeDepth:[Element]] = [:]
        for item in self {
            let depth = item.depthInTree // note: CPU intensive
            result[depth] = result[depth]?.appending(item) ?? [item]
        }
        return result
    }
    
    var asDictByNodeType: [MNTreeNodeType:[Element]] {
        var result : [MNTreeNodeType:[Element]] = [:]
        for item in self {
            let depth = item.treeNodeType // note: CPU intensive
            result[depth] = result[depth]?.appending(item) ?? [item]
        }
        return result
    }
}

extension Array where Element : MNTreeNodeProtocol, Element.ID : Comparable {
    var sortedById : [Element] {
        return self.sorted { node1, node2 in
            return node1.id < node2.id
        }
    }
}

extension Array where Element : MNTreeNodeProtocol, Element.Value : Comparable {
    var sortedByValue : [Element] {
        return self.sorted { node1, node2 in
            guard let node1Val = node1.value else {
                return node2.value != nil ? false : true
            }
            guard let node2Val = node2.value else {
                return true
            }
            
            return node1Val < node2Val
        }
    }
}
