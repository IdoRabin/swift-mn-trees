//
//  MNTreeNodeBaseProtocol.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

/// The depth in the tree for a tree node (Distance to the root node)
public typealias MNTreeNodeDepth = Int

// A class for a generic node
public protocol MNTreeNodeBaseProtocol<ID, Value> : MNNodeProtocol {
    
    /// The maximum allowed "depth" for any of the tree's nodes.
    /// NOTE: this is a default implementated-value which can be overriden by implementors.
    static var MAX_TREE_DEPTH : Int { get }
    
    /// The maximum allowed "depth" for any of the tree's nodes.
    /// NOTE: this is a default implementated-value which can be overriden by implementors.
    var MAX_TREE_DEPTH : Int { get }
    
    /// Array (read only) of child-nodes of this N-tree
    var children : [Self] { get set }
    
    /// Parent (read only) of this node in this N-tree.
    /// Implementors should make this weak when applicable.
    var parent : Self? { get set }
    
    /// A string describing the flavour, or kind of the whole homogeneous tree vis-a-vie its implementor and generic components. Can be used as an indexing key (foreign key?)
    var treeKindKey : MNKindKey { get }
    
    /// Returns whether the node is a root, branch or leaf in the N-tree structure
    var treeNodeType : MNTreeNodeType { get }
    
    /// Returns whether the node is the root in the N-tree structure
    var isRoot : Bool { get }
    
    /// Returns whether the node is a leaf in the N-tree structure
    var isLeaf : Bool { get }
    
    /// Returns whether the node is a branch in the N-tree structure
    var isBranch : Bool { get }
    
    /// Returns the root of this specific tree. (self if this is the root)
    var root :  Self { get }
    
    /// List of all siblings (i.e have the same parent).
    /// NOTE: siblings does not include self. Element count & indexes NOT the same as parent.children!
    var siblings: [Self]? { get }
    
    /// Returns true if this node of the N-Tree has children.
    var hasChildren : Bool  { get }
    
    /// Returns true if this node in the N-Tree has a parent (all nodes except the root should have a parent).
    var hasParent : Bool  { get }
    
    /// Returns true if this node's value is non-nil
    var hasValue : Bool { get }
    
    /// Returns the distance from the root of this node in the tree.
    var depthInTree : MNTreeNodeDepth { get }
    
    /// Returns the distance from the root of this node in the tree.
    @available(*, deprecated, renamed: "depthInTree", message: ".depth has been renamed .depthInTree which now uses the typealais MNTreeNodeDepth (Int), please rename.")
    var depth : Int { get }
    
    /// Will return true if this node is the last child in the .children list of its parent.
    /// NOTE: returns false for a root node.
    var isParentsLastChild : Bool { get }
    
    /// Will return true if this node is the first child in the .children list of its parent.
    /// NOTE: returns false for a root node.
    var isParentsFirstChild : Bool { get }
    
    /// Get all children (recoursively downtree) of the current node as a dictionary of arrays of nodes, keyed by depth
    /// - Parameter includeSelf: includeSelf: determines whether the traversal tests include the self (starting) node or not.
    /// - Returns: a dictionary where node depth (distance from root) is the key, and array of nodes of that depth are the value.
    func allChildrenDictByDepth(includeSelf:Bool)->[Int : [Self]]
    
    /// Get all children (recoursively downtree) of the current node as an array of nodes, sorted by depth
    /// - Parameter includeSelf: includeSelf: includeSelf: determines whether the traversal tests include the self (starting) node or not.
    /// - Returns: and array of all child nodes for this node, sorted by their depth (distance to root node)
    func allChildrenArraySortedByDepth(includeSelf:Bool)->[Self]
    
    /// Get an array of all direct children's ids
    /// - Returns: array of MNTreeNodeBaseProtocol.IDValue
    func childrenIds() ->[ID]
    
    /// Get an array of all direct children's values
    /// - Returns:array of MNTreeNodeBaseProtocol.ValueType
    func childrenValues() ->[Value]
    
}

public extension MNTreeNodeBaseProtocol /* default implementations */ {
    
    var treeKindKey : MNKindKey {
        return self.graphKindKey
    }
    
    var treeNodeType : MNTreeNodeType {
        if self.parent == nil {
            return .root
        }
        
        if self.children.count == 0 {
            return .leaf
        }
        
        return .branch
    }
    
    var isRoot: Bool {
        self.treeNodeType == .root
    }
    
    var isLeaf: Bool {
        self.treeNodeType == .leaf
    }
    
    var isBranch: Bool {
        self.treeNodeType == .branch
    }
    
    var siblings: [Self]? {
        get {
            return parent?.children.removing(where: {$0.id == self.id }) as? [Self]
        }
    }
    
    /// Will return true is is the last sibling or if no siblings at all
    var isParentsLastChild : Bool {
        guard let children = self.parent?.children, children.count > 0 else {
            // root or no siblings?
            return true
        }
        
        return children.last == self
    }
    
    /// Will return true is is the first sibling or if no siblings at all
    var isParentsFirstChild : Bool {
        guard let children = self.parent?.children, children.count > 0 else {
            // root or no siblings?
            return true
        }
        
        return children.first == self
    }
    
    var hasChildren : Bool {
        return self.children.count > 0
    }
    
    var hasParent : Bool {
        return self.parent != nil
    }
    
    var hasValue : Bool {
        return self.value != nil
    }
    
    /// Depth of the node in the tree (in relation to the root)
    var depthInTree : Int {
        get {
            // NOTE: Loop with infitie potential!
            var counter = 0
            var item : Self? = self
            while item?.parent != nil && counter <= MNGraphs.MAX_RECURSION_DEPTH {
                counter += 1
                item = item?.parent
            }
            
            // TODO: Debug validations should see item?.isRoot == true here
            
            if counter >= MNGraphs.MAX_RECURSION_DEPTH {
                fatalError(MNTreeError.maxRecurstionDepthReached.desc +
                           "MNTreeNodeBaseProtocol.\(Self.self).depth created a recursion / while too deep. MAX: \(MNGraphs.MAX_RECURSION_DEPTH)")
            }
            return counter
        }
    }
    
    func childrenIds() ->[ID] {
        return self.children.map { $0.id }
    }
    
    func childrenValues() ->[Value] {
        return self.children.compactMap { $0.value }
    }
}





