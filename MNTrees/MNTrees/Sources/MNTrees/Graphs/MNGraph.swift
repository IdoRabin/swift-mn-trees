//
//  MNGraph.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

import Foundation

public typealias MNGraphName = String

public protocol MNGraphConfig : Sendable, Codable, Hashable {
    var graphType : MNGraphType { get }
    var isEncodesFlat : Bool { get }
}

public protocol MNGraph : Sendable, Codable, Hashable {
    var config : any MNGraphConfig { get set }
    var name : MNGraphName? { get }
    
    var graphType : MNGraphType { get } // derived from config
}

public extension MNGraph /* default implementations */ {

    var graphType : MNGraphType {
        return config.graphType
    }
}
    
