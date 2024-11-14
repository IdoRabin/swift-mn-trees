//
//  MNNodeProtocol+Cosing.swift
//  MNTree
//
//  Created by ido on 30/10/2024.
//

import MNUtils

// MARK: - Coding
/// Extension for Codable implementation of MNNodeProtocol
/// codable but key and value are not Codable
public extension MNNodeProtocol  where Self : Codable {
    init(from decoder: any Decoder) throws {
        if !(Value.self is Codable) || !(ID.self is Codable) {
            throw MNError(.misc_failed_decoding, reason: "\(Self.self) cannot be enc/decoded because ID: \(ID.self) or Value:\(Value.self) do not conform to Codable!")
        }
        
        // Assuming the extension where Self:Codable, ID : Codable, Value : Codable is eagerly covering the functions
        fatalError("\(Self.self) error: .misc_failed_decoding for an unknown reason: could be missing/unresolved Codable in ID or Value?")
    }
    
    func encode(to encoder: any Encoder) throws {
        if !(Value.self is Codable) || !(ID.self is Codable) {
            throw MNError(.misc_failed_encoding, reason: "\(Self.self) cannot be encoded because ID: \(ID.self) or Value:\(Value.self) do not conform to Codable!")
        }
        
        // Assuming the extension where Self:Codable, ID : Codable, Value : Codable is eagerly covering the functions
        fatalError("\(Self.self) error: .misc_failed_encoding for an unknown reason: could be missing/unresolved Codable in ID or Value?")
    }
}

extension MNNodeProtocol /* codable implementation */ where Self : Codable, Self.ID : Codable, Self.Value : Codable {
    
    typealias BaseCodingKeys = MNNodeCodingKeys
    typealias CodingKeys = Self.BaseCodingKeys // association is combined with the <ID, ValueTyoe> generic thingie
    
    public func encode(to encoder: any Encoder) throws {
        guard Self.self is Encodable else {
            throw MNError(code:.misc_failed_encoding, reason: "MNTreeNodeProtocol.encode failed. Type \(Self.self) is not en/codable!")
        }
        
        fatalError("MNTreeNodeProtocol.encode not implemented \(Self.self)")
    }
    
    init(from decoder: any Decoder) throws {
        guard Self.self is Decodable else {
            throw MNError(code:.misc_failed_encoding, reason: "MNTreeNodeProtocol.decode failed. Type \(Self.self) is not de/codable!")
        }
        
        fatalError("MNTreeNodeProtocol.decode not implemented \(Self.self)")
    }
}
