//
//  MNTreeNodeCodingKeys.swift
//  MNTree
//
//  Created by ido on 30/10/2024.
//

// import Foundation

// MARK: NSCoding

// MARK: Encoding keys:
public enum MNTreeNodeCodingKeys : String, CodingKey {
    case id = "id"
    case value = "value"
    case children = "children"
    case parent = "parent"
    case childrenIds = "children_ids"
    case parentId = "parent_id"
    case info = "info"
}

// MARK: Encoder "config" keys
public enum MNTreeNodeCodingUserInfoKeys : String, CaseIterable, Hashable {
    
    case encodesFlat = "encodes_flat"
    case encodesWithInfo = "encodes_with_info"
    
    var asCodingUserInfoKey : CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: self.rawValue)!
    }
    
    static func typeDescriptorForCase(_ item:Self)->Any.Type {
        let dict : [MNTreeNodeCodingUserInfoKeys:Any.Type] = [
            .encodesFlat : Bool.self,
            .encodesWithInfo : Bool.self
        ]
        
        return dict[item]!
    }
    
    var typeDescriptor : Any.Type {
        return Self.typeDescriptorForCase(self)
    }
}

// MARK: Dictionary where Key == MNTreeNodeCodingUserInfoKeys, Value == Any
public extension Dictionary where Key == MNTreeNodeCodingUserInfoKeys, Value == Any {
    
    var asCodingUserInfoDic : [CodingUserInfoKey : Any] {
        var result : [CodingUserInfoKey : Any] = [:]
        for (k,v) in self {
            result [k.asCodingUserInfoKey] = v
        }
        return result
    }
    
    init(dict:[CodingUserInfoKey : Any]) {
        self.init()
        for (k,v) in dict {
            if let enumKey = MNTreeNodeCodingUserInfoKeys.init(rawValue: k.rawValue) {
                self[enumKey] = v
            }
        }
    }
}

// MARK: Dictionary where Key == MNTreeNodeCodingUserInfoKeys, Value == Any
public extension Dictionary where Key == CodingUserInfoKey, Value == Any {
    var asMNTreeNodeCodingUserInfoKeys : [MNTreeNodeCodingUserInfoKeys:Any] {
        var result : [MNTreeNodeCodingUserInfoKeys:Any] = [:]
        for (k,v) in self {
            if let k = MNTreeNodeCodingUserInfoKeys.init(rawValue: k.rawValue) {
                result[k] = v
            }
        }
        return result
    }
}
