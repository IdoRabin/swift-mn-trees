//
//  MNTreeNodeProtocol+Cosing.swift
//  MNTree
//
//  Created by ido on 30/10/2024.
//

import MNUtils

// Allows coding
extension MNTreeNodeProtocol /* codable but key and value are not Codable */ where Self : Codable {
    init(from decoder: any Decoder) throws {
        if !(Value.self is Codable) || !(ID.self is Codable) {
            throw MNError(.misc_failed_decoding, reason: "\(Self.self) cannot be enc/decoded because ID: \(ID.self) or Value:\(Value.self) do not conform to Codable!")
        }
        
        // Assuming the extension where Self:Codable, ID : Codable, Value : Codable is eagerly covering the functions
        fatalError("\(Self.self) error: .misc_failed_decoding for an unknown reason: could be missing/unresolved Codable in ID or Value?")
    }
    
    public func encode(to encoder: any Encoder) throws {
        if !(Value.self is Codable) || !(ID.self is Codable) {
            throw MNError(.misc_failed_encoding, reason: "\(Self.self) cannot be encoded because ID: \(ID.self) or Value:\(Value.self) do not conform to Codable!")
        }
        
        // Assuming the extension where Self:Codable, ID : Codable, Value : Codable is eagerly covering the functions
        fatalError("\(Self.self) error: .misc_failed_encoding for an unknown reason: could be missing/unresolved Codable in ID or Value?")
    }
}

extension MNTreeNodeProtocol /* codable implementation */ where Self : Codable, Self.ID : Codable, Self.Value : Codable {
    
    typealias TreeCodingKeys = MNTreeNodeCodingKeys
    typealias TreeInfoKeys = MNTreeNodeCodingUserInfoKeys
    
    public func encode(to encoder: any Encoder) throws {
        guard Self.self is Encodable else {
            throw MNError(code:.misc_failed_encoding, reason: "MNTreeNodeProtocol.encode failed. Type \(Self.self) is not en/codable!")
        }
        
        var container = encoder.container(keyedBy: TreeCodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.value, forKey: .value)
    
        // MNTreeNodeCodingUserInfoKeys
        let auserInfo : [TreeInfoKeys:Any] = encoder.userInfo.asMNTreeNodeCodingUserInfoKeys
        let isFlat = auserInfo[.encodesFlat] as? Bool == true
        if isFlat {
            // Encoding with flat tree:
            // Get root
            // let root = self.root
            
            // Get all nodes by depth
            // let nodesByDepth = root.allChildrenArraySortedByDepth(includeSelf: true)
            
            // Save in flat array with ids
            // TODO: Complete implementation
            print("TODO: Complete implementation of flat encode")
        } else {
            // Encoding with full tree:
            // save this node only
            if let cparent = self.parent {
                try container.encodeIfPresent(cparent, forKey: .parent)
            }
            if children.count > 0 {
                try container.encode(self.children, forKey: .children)
            }
        }
        
        // User info
        if auserInfo[.encodesWithInfo] as? Bool == true  {
            // Save one-node info
            // Saving info for the whole tree only in the flat tree
            // TODO: Save info?
        }
    }
    
    init(from decoder: any Decoder) throws {
        guard Self.self is Decodable else {
            throw MNError(code:.misc_failed_encoding, reason: "MNTreeNodeProtocol.encode failed. Type \(Self.self) is not de/codable!")
        }
        typealias Keys = MNTreeNodeCodingKeys
        
        // Decode
        let container = try decoder.container(keyedBy: Keys.self)
        let newId = try container.decode(ID.self, forKey: Keys.id)
        let newValue = try container.decodeIfPresent(Value.self, forKey:Keys.value)
        
        let newChildren : [Self] = try container.decodeIfPresent([Self].self, forKey: Keys.children) ?? []
        let newParent : Self? = try container.decodeIfPresent(Self.self, forKey: Keys.parent)
        
        try self.init(id: .id(newId), value: newValue, parent: newParent, children: newChildren)
    }
}
