//
//  MNEdgeType.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

public enum MNEdgeType : Sendable, CaseIterable, CustomStringConvertible {
    case to
    case from
    case bidi
    
    public var description: String {
        switch self {
        case .to: return "to"
        case .from: return "from"
        case .bidi: return "bidi"
        }
    }
    
    public var descriptionChars: String {
        switch self {
        case .to: return "→" // big arrow right
        case .from: return "⇠" // dotted arrow left
        case .bidi: return "⇄" // double arrow left-right (bidirectional)
        }
    }
}
