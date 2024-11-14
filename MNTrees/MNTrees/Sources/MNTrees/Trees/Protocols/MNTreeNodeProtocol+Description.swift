//
//  File.swift
//  MNTree
//
//  Created by ido on 25/10/2024.
//

// import Foundation

extension MNTreeNodeProtocol where Self : CustomDebugStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        return "<\(self.treeKindKey) id: \(id) val: \(value.descOrNil)>"
    }
    
    // MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        var desc = self.description.trimmingSuffix(">")
        desc += self.hasParent ? " prnt: \(parent!.id)" : "isRoot"
        desc += self.hasChildren ? " (\(self.children.count) children)" : ""
        desc += ">"
        return desc
    }
}

extension MNTreeNodeProtocol where Self : CustomStringConvertible {
// ,  {
    // MARK: CustomStringConvertible
    public var description: String {
        return "<\(self.treeKindKey) id: \(id) val: \(value.descOrNil)>"
    }
    
    
    public var debugTreeDescription: String {
        let key = self.treeKindKey
        var result : String = "= Tree for \(key) id: [\(root.id)] ="
        for line in self.debugTreeStrings {
            result += "\n\(line)"
        }
        return result
    }
    
    // MARK: MNTreeNode
    var debugTreeStrings : [String] {
        let lines : [String] = self.root.traversingItems(.depthFirst, includeSelf: true) { node, nodeDepth in
            let isLast = node.isParentsLastChild
            // dlog?.info("node: \(node.id) depth: \(nodeDepth) isLast:\(isLast) siblings:\(node.siblings?.count ?? 0) parent:\(node.isRoot ? "<nil>" : "\(node.parent!.id)")")
            var prefix = ""
            if node.parent?.isParentsLastChild == true {
                prefix = "  ".repeated(times: nodeDepth - 1)
            } else {
                prefix = "┃ ".repeated(times: nodeDepth - 1)
            }
            switch node.treeNodeType {
            case .root:
                prefix = node.hasChildren ? "┳" :  "━"
            case .branch:
                prefix += (isLast ? "┗━┳" : "┣━┳")
            case .leaf:
                prefix += (isLast ? "┗" : "┣") + "━━"
            }
            return .resume("\(prefix) id:[\(node.id)] value: \(node.hasValue ? String(describing: node.value!).substring(upTo: 15, suffixIfClipped: "..").trimmingCharacters(in: .whitespacesAndNewlines) : "nil")")
        }.value ?? []
        return lines
    }
}
