//
//  MNTreeNodeTraversal.swift
//  MNTree
//
//  Created by ido on 31/10/2024.
//

@preconcurrency import DSLogger
import MNUtils

// Logger
fileprivate let dlog : DSLogger? = DLog.forClass("MNTreeNodeTraversal")?.setting(verbose: true)

// MARK: Traversal functions protocol for the tree
public protocol MNTreeNodeTraversal<ID, Value> : MNTreeNodeBaseProtocol, Equatable, Hashable {
    
    typealias TestBlock = (_ node:Self, _ nodeDepth:MNTreeNodeDepth)->Bool
    
// ====== Generic results (i.e <ResultType : Any> is the result type) =======
    
    
    /// Will iterate up / down the tree from the current node using the traversalOrder and the includeSelf flag, The result may be any generic result created in the block
    /// - Parameter block: block to apply upon each node in the traversal. Return a result of ResultType to be collated to the final result for the whole traversal. return .stop(value and/or error) to stop the traversal. Return .resume(ResultType or nil) to resume the traversal. Only the .stop and .resume results that contain a non-nil value are collated during the traversal.
    /// NOTE: The use of the MNFlowResult is mainly for optimizing the traversal to stop work as soon as deemed appropriate by the caller, thus, saving the resources of iterating over the remainder of the tree if not needed.
    /// - Parameter traversalOrder: order of traversal in the tree
    /// - Parameter includeSelf: determines whether the traversal tests include the self (starting) node or not.
    /// - Returns: Flow result containing and array of ResultType - all block results that were returned non-nil during the traversal.
    func traversingItems<ResultType : Any>(_ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool, block:(_ node:Self, _ nodeDepth:MNTreeNodeDepth)->MNFlowResult<ResultType?>)->MNFlowResult<[ResultType]>
    
    /// Will iterate up / down the tree from the current node using the traversalOrder and the includeSelf flag, The result may be any generic type returned by the block.
    /// NOTE: This function does not optimize for flow control and traverses the whole traversalOrder of the tree, with no stopping.
    /// - Parameters:
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: determines whether the traversal tests include the self (starting) node or not.
    ///   - block: block to apply upon each node in the traversal. Return a result of ResultType to be collated to the final result for the whole traversal. return nil if the result should not be added to the final result array. resurning nil does NOT stop the iteration of children/parents of the tested node.
    /// - Returns: Flow result containing and array of ResultType - all block results that were returned non-nil during the traversal.
    func filteringToGenric<ResultType : Any>(_ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool, block:(_ node:Self, _ nodeDepth:MNTreeNodeDepth)->ResultType?)->MNFlowResult<[ResultType]>
   
    /// Find the first N items up/down the tree that match a boolean `where` test block.
    /// NOTE: This function is optimized to stop the traversalOrder recursion once the first N results / items were returned from the test block.
    /// - Parameters:
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: determines whether the traversal tests include the self (starting) node or not.
    ///   - block: block to apply upon each node in the traversal. Return a result of ResultType to be collated to the final result for the whole traversal. return nil if
    /// - Returns: the first N Items (or less) in the traversal that the `where` block tested as passing (true)
    func firstToGenericN_Items<ResultType : Any>(n:Int, traversalOrder: MNTreeTraversalOrder, includeSelf:Bool, block:(_ node:Self, _ nodeDepth:MNTreeNodeDepth)->ResultType?)->MNFlowResult<[ResultType]>
    
    /// Find the first N nodes up/down the tree that match a boolean `where` test block.
    /// NOTE: This function is optimized to stop the traversalOrder recursion once the first N nodes were found.
    /// - Parameters:
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: sdetermines whether the traversal tests include the self (starting) node or not.
    ///   - block:
    /// - Returns: the first N-nodes (or less) in the traversal that the `where` block tested as passing (true)
    func firstToGenericItem<ResultType : Any>(_ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool, block:(_ node:Self, _ nodeDepth:MNTreeNodeDepth)->ResultType?)->MNFlowResult<[ResultType]>
    
   
// ====== Node results (i.e NodeType is the result type) =======
    /// Filter all nodes up/down the tree using a boolean `where` test block.
    /// NOTE: This function is NOT optimized to stop the recursion until all elements in the traversalOrder were tested.
    /// - Parameters:
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: determines whether the traversal tests include the self (starting) node or not.
    ///   - test: block returns true if the node is to be included in the result, false otherwise
    /// - Returns: all the nodes in the traversal that the `where` block tested as passing (true)
    func filteringNodes(_ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool, `where` test:(_ node:Self, _ nodeDepth:MNTreeNodeDepth)->Bool)->MNFlowResult<[Self]>
    
    /// Find the first node up/down the tree that matches a boolean `where` test block.
    /// NOTE: This function is optimized to stop the traversalOrder recursion once the first node was found.
    /// - Parameters:
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: determines whether the traversal tests include the self (starting) node or not.
    ///   - test: block returns true if the node is to be included in the result, false otherwise
    /// - Returns: the first node in the traversal that the `where` block tested as passing (true)
    func firstNode(_ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool, `where` test:(_ node:Self, _ nodeDepth:MNTreeNodeDepth)->Bool)->MNFlowResult<Self>
    
    
    /// Find the first N nodes up/down the tree that match a boolean `where` test block.
    /// NOTE: This function is optimized to stop the traversalOrder recursion once the first N nodes were found.
    /// - Parameters:
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: determines whether the traversal tests include the self (starting) node or not.
    ///   - test: block returns true if the node is to be included in the result, false otherwise
    /// - Returns: the first N-nodes (or less) in the traversal that the `where` block tested as passing (true)
    func firstNNodes(n:Int, traversalOrder: MNTreeTraversalOrder, includeSelf:Bool, `where` test:(_ node:Self, _ nodeDepth:MNTreeNodeDepth)->Bool)->MNFlowResult<[Self]>
    
    
}

/// Convenience search functions that are derived from using MNTreeNodeTraversal functions, and already havar default implementation.
public protocol MNTreeNodeTraversalConvenience<ID, Value> : MNTreeNodeBaseProtocol, MNTreeNodeTraversal, Equatable, Hashable {
    
    /// Find nodes by a given test condition in a block
    /// TODO: Determine if raised errors from within the tests are thrown, logged or ignored. Currently logged.
    /// - Parameters:
    ///   - test: test block to determine if the node is included in the search results
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: determines whether the traversal tests include the self (starting) node or not.
    /// - Returns: array of nodes that passed the test
    func findNodes(where test:(_ node:Self,  _ nodeDepth:MNTreeNodeDepth)->Bool, _ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool)->[Self]
    
    /// Search that is optimized for searching at a specific level of the tree
    /// TODO: Determine if raised errors from within the tests are thrown, logged or ignored. Currently logged.
    /// - Parameters:
    ///   - atTreeDepth: depth of three (from the root) to search in
    ///   - test: test block to determine if the node is included in the search results
    ///   - traversalOrder: order of traversal up/down the tree (starting at the current node).
    ///   - includeSelf: determines whether the traversal tests include the self (starting) node or not.
    /// - Returns: array of nodes from the required depth in the tree that also passed the test
    func findNodes(atTreeDepth reqDepth:MNTreeNodeDepth, where test:((_ node:Self)->Bool)?, _ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool)->[Self]
    
    /// get the first (assumed only) child by the given id, or nil if not found
    /// - Parameters:
    ///   - byId: id to search for
    ///   - downtree: determines if the search is performed on direct children inly or all descendants of this node downtree.
    /// - Returns: the (first) node encountered by that id or nil
    func child(byId:ID, downtree:Bool)->Self?
    
    
    /// get the first child with the given value (equatale), or nil if not found
    /// - Parameters:
    ///   - byValue: Value to search for
    ///   - downtree: determines if the search is performed on direct children only or all descendants of this node downtree.
    /// - Returns: the first node encountered by that value or nil
    func child(byValue:Value, downtree:Bool)->Self?
}

// MARK: MNTreeNodeTraversalConvenience default implementations
public extension MNTreeNodeTraversalConvenience /* default implementation*/ {
    
    func findNodes(where test:(_ node:Self,  _ nodeDepth:MNTreeNodeDepth)->Bool, _ traversalOrder: MNTreeTraversalOrder = .depthFirst, includeSelf:Bool = true)->[Self] {
        // Find all nodes that pass the test
        let result = self.filteringNodes(traversalOrder, includeSelf: includeSelf, where: test)
        if let err = result.error {
            dlog?.note("findNodes(where:...) encountered an error within the search. error: \(err.description)")
        }
        return result.value ?? []
    }
    
    func findNodes(atTreeDepth reqDepth:MNTreeNodeDepth, where test:((_ node:Self)->Bool)?, _ traversalOrder: MNTreeTraversalOrder, includeSelf:Bool)->[Self] {
        // Find all nodes at reqDepth - 1
        let result : MNFlowResult<[Self]> = self.traversingItems(traversalOrder, includeSelf: includeSelf) { node, nodeDepth in
            guard nodeDepth < reqDepth else {
                return .resumeEmpty
            }
            
            if nodeDepth == reqDepth && test?(node) ?? true == true {
                return .resume(node)
            }
            
            return .resumeEmpty
        }
        
        if let err = result.error {
            dlog?.note(".findNodes(findNodes(atTreeDepth:where:...) encountered an error within the search. error: \(err.description)")
        }
        return result.value ?? []
    }
    
    func child(byId:ID, downtree:Bool = false)->Self? {
        guard byId != self.id else {
            dlog?.note(".child(byId...) the searched child id is the same as the current node id, but this will not appear as the result, as this search only searches children.")
            return nil
        }

        if downtree {
            return self.firstNode(.breadthFirst, includeSelf: false, where: {node, _ in node.id == byId}).value
        } else {
            return self.children.first{ $0.id == byId}
        }
    }
    
    func child(byValue:Value, downtree:Bool = false)->Self? {
        if byValue == self.value {
            dlog?.note(".child(byValue...) the searched child value is the same as the current node value, but will not appear as the result, as this search only searches children.")
        }
        
        if downtree {
            return self.firstNode(.breadthFirst, includeSelf: false, where: {node, _ in node.value == byValue}).value
        } else {
            return self.children.first{ $0.value == byValue}
        }
    }
    
}
