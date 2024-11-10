//
//  MNTreeNodeProtocl.swift
//  MNTrees
//
//  Created by ido on 10/11/2024.
//

// A class for a generic node
protocol MNTreeNodeProtocol<ID, Value> : MNNodeProtocol {
    
    var children : [Self] { get set }
    var parent : Self? { get set }
    
}

extension MNTreeNodeProtocol /* default implementations */ {

}



