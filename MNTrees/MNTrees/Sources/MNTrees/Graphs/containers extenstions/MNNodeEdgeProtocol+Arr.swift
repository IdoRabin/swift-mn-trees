//
//  MNNodeEdgeProtocol+Arr.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

extension Sequence where Element : MNNodeEdgeProtocol {
    func edges(byType:MNEdgeType)->[Element] {
        return self.filter { $0.type == byType }
    }
}
