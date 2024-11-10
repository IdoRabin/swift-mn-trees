//
//  MNNodeEdgeProtocol.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

public enum MNEdgeType {
    case to
    case from
    case child
}

public protocol MNNodeEdgeProtocol<NodeType> {
    associatedtype NodeType = MNNodeProtocol
    
    var from : Self { get set }
    var to : Self { get set }
    var type : MNEdgeType { get set }
}

extension Sequence where Element : MNNodeEdgeProtocol {
    func edges(byType:MNEdgeType)->[Element] {
        return self.filter { $0.type == byType }
    }
}
