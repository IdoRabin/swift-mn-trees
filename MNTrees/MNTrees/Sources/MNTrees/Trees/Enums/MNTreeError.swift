//
//  MNTreeError.swift
//  MNTree
//
//  Created by ido on 21/10/2024.
//

import MNUtils

enum MNTreeError: Error, DisplayStringable {
    case nodeNotFound
    case circularReference
    case invalidParent
    case maxRecurstionDepthReached
    case maxTreeDepthReached
    
    // MARK: DisplayStringable
    public var displayString : DisplayString {
        switch self {
        case .nodeNotFound:
            return "Node/s not found"
        case .circularReference:
            return "There is a circular reference between nodes in the tree!"
        case .invalidParent:
            return "Node has an invalid parent"
        case .maxRecurstionDepthReached:
            return "Max recursion depth reached \(MNGraphs.MAX_RECURSION_DEPTH)"
        case .maxTreeDepthReached:
            return "Max tree depth reached \(MNTrees.MAX_TREE_DEPTH))"
        }
    }
    
    func asMNError(details:String? = nil)->MNError {
        var reason = "MNTree operation error (\(self.displayString)."
        if let details {
            reason += " detail: \(details)"
        }
        return MNError(code: .http_stt_internalServerError,
                       reason: reason,
                       underlyingError: self)
    }
}

extension MNTreeError : MNErrorable {
    public var desc: String {
        self.description
    }
    
    public var domain: String {
        "MNTree"
    }
    
    public var reason: String {
        self.displayString
    }
    
    public var code : MNErrorInt { MNErrorCode.misc_failed_validation.code  }
}


