//
//  MNTreeNodeProtocol.swift
//  MNTree
//
//  Created by ido on 24/10/2024.
//

// import Foundation
import MNUtils
@preconcurrency import DSLogger

// Logger
fileprivate let dlog : DSLogger? = DLog.forClass("MNTreeNodeProtocol")?.setting(verbose: true)

// MARK: MNTreeNodeProtocol
/// This protocol unifies the MNTreeNodeBaseProtocol base protocol and the MNTreeNodeTraversal protocol
/// NOTE: Some properties and functions of this protocol have a default implementation. Implelemtors of this protocol should review those.
public protocol MNTreeNodeProtocol : MNTreeNodeBaseProtocol, MNTreeNodeTraversal, MNTreeNodeTraversalConvenience, Equatable, Hashable, Sendable {
    
//    associatedtype IDType = IDType
//    associatedtype ValueType = ValueType
//    associatedtype NodeType = MNTreeNode<IDType, ValueType>
    associatedtype NodeResult = MNResult<Self?>
    associatedtype NodesResult = MNResult<[Self]>
    
    
    /// Get the child at the N-th index, if it exists
    /// - Parameter index: integer index for the child, starting from 0
    /// - Returns: the child node, or nil if not found
    func childAt(_ index:Int)->Self?
    
    /// Get the sibling at the N-th index, if it exists
    /// - Parameter index: integer index for the sibling, starting from 0
    /// - Returns: the sibling node, or nil if not found
    func siblingAt(_ index:Int)->Self?
    
    // MARK: CRUD Operations
    // (the implementor needs to implement the CRUD operations, no default implementation exist)
    
    /// Add child nodes to the current tree node (as direct children)
    /// - Parameter nodes: nodes to add
    /// - Returns: succes(array of all nodes that were successfully added) or failure(error)
    @discardableResult
    func addChildren(nodes: [Self])->NodesResult
    
    
    /// Add a single child node to the current tree node (as a direct child)
    /// - Parameters:
    ///   - node: node to add as a child
    ///   - expecting: number of children expected to have been successfully added (usually 0 or 1)
    /// - Returns: succes(node) or failure(error)
    @discardableResult
    func addChild(node: Self, expecting:Int)->NodeResult
    
    
    /// Remove direct child nodes from the current tree node (as direct children)
    /// NOTE: This function will remove all children which are equal (using Equatable) to the nodes parameter. Ownership and release of the removed nodes is the responsibility of the caller.
    /// - Parameter nodes: nodes to remove
    /// - Returns: succes(array of all nodes that were successfully removed) or failure(error)
    @discardableResult
    func removeChildren(nodes: [Self])->NodesResult
    
    /// Remove a single child node from the current tree node (as a direct child)
    /// NOTE: This function will remove all children which are equal (using Equatable) to the node parameter. Ownership and release of the removed node is the responsibility of the caller.
    /// - Parameters:
    ///   - node: node to remove
    ///   - expecting: number of children expected to have been successfully removed (usually 0 or 1)
    /// - Returns : succes(node that was removed) or failure(error)
    @discardableResult
    func removeChild(node: Self, expecting:Int)->NodeResult
    
    
    /// A reference to the Tree that this node belongs to
    var tree : any MNTree { get }
    
    
    /// "required" init with the id and value for this node
    /// - Parameters:
    ///   - id: id for the new node
    ///   - value: (optional) value for the new node
    // Declared int MNNode:  init(id:MNNodeNewID<ID>, value:Value?)
    
    /// "required" init with the id, value and possible parent / children for this node
    /// NOTE: the nodes in paremeters parent and children may be "moved" in the tree from previous parents / children to comply with the defined structure.
    /// - Parameters:
    ///   - id: id for the new node
    ///   - value: (optional) value for the new node
    ///   - parent: (optional) parent for the new node
    ///   - children: (optional) array of child nodes for this node.
    init(id newId:MNNodeNewID<ID>, value newValue:Value?, parent newParent:Self?, children newChildren: [Self]?) throws
}

// MARK: MNTreeNodeProtocol - default implementation
public extension MNTreeNodeProtocol /* default implementation */ {
    
    
    /// Returns the child at the n-th index, if it exists (silently fails returning nil)
    /// - Parameter index: integer index of the child as it is currently sorted, starting from 0.
    /// - Returns: the node, or nil if not found (children may be too small, index out of bounds return nil as well)
    func childAt(_ index:Int)->Self? {
        guard index >= 0, self.children.count > 0, index < self.children.count   else {
            return nil
        }
        
        return self.children[index]
    }
    
    
    /// Returns the sibling at the n-th index for this node, if it exists (silently fails returning nil)
    /// NOTE: This interface implicitly excludes the node itself from the list of siblings, i.e self will not be found in self.siblings.
    /// - Parameter index: index: integer index of the sibling as it is currently sorted, starting from 0.
    /// - Returns: the node, or nil if not found (siblings may be too small, index out of bounds return nil as well)
    func siblingAt(_ index:Int)->Self? {
        guard let siblings = self.siblings else {
            return nil
        }
        guard index >= 0, siblings.count > 0, index < siblings.count else {
            return nil
        }
        
        return siblings[index]
    }
}
