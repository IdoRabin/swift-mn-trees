//
//  MNTreeNodeProtocol+Dictionary.swift
//  MNTree
//
//  Created by ido on 30/10/2024.
//

public extension Dictionary where Key : MNTreeNodeProtocol {
    
    /// Returns an array of Tree nodes sorted by their depth
    /// NOTE: Not optimized, not efficient.
    /// TODO: Override this in concrete types?
    var keysTreeNodesSortedByDepth : [any MNTreeNodeProtocol] {
        return self.keysArray.sorted { node1, node2 in
            return node1.depthInTree < node2.depthInTree
        }
    }
}

public extension Dictionary where Value : Sequence<any MNTreeNodeProtocol> {
    
    /// Returns an array of Tree nodes sorted by their depth
    /// NOTE: Not optimized, not efficient.
    /// TODO: Override this in concrete types?
    var valueTreeNodesSortedByDepth : [any MNTreeNodeProtocol] {
        return self.valuesArray.flattened.sorted { node1, node2 in
            return node1.depthInTree < node2.depthInTree
        }
    }
}

extension Dictionary where Value : MNTreeNodeBaseProtocol {
    
    /// Returns an array of Tree nodes sorted by their depth
    /// NOTE: Not optimized, not efficient.
    /// TODO: Override this in concrete types?
    var valuetreeNodesSortedByDepth : [Value] {
        return self.valuesArray.sorted { node1, node2 in
            return node1.depthInTree < node2.depthInTree
        }
    }
}
