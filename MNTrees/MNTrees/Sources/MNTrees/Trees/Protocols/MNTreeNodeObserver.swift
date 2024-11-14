//
//  MNTreeNodeObserver.swift
//  MNTree
//
//  Created by ido on 04/11/2024.
//

import Foundation
import MNUtils

public enum MNTreeNodeEvent : String, CaseIterable, Sendable {
    case didInit
    case willDeinit
    case willChangeParent
    case didChangeParent
    case didChangeTreeRoot
    case didChangeValue
}

public enum MNTreeNodeNotifDirection : String, CaseIterable, Sendable {
    case bubbleUp
    case bubbleDown
    case noBubble
    case directToRoot
    
    var isBubbling: Bool {
        return [.bubbleUp, .bubbleDown].contains(self)
    }
}

// Definition of MNTreeNodeChange struct
public struct MNTreeNodeChange : CustomStringConvertible, Sendable {
    typealias NodeType = any MNTreeNodeProtocol
    let eventType: MNTreeNodeEvent
    let direction: MNTreeNodeNotifDirection
    let subjects: [NodeType]
    let from: NodeType?
    let to: NodeType?
    let context: String?
    
    public var description: String {
        var result = ".\(eventType)("
        
        if subjects.count > 0 {
            result += "subjects: \( subjects.map { $0.id } ) "
        }
        
        if let from = from {
            result += "from: \(from.id) "
        }
        if let to = to {
            result += "to: \(to.id) "
        }
        if let context = context {
            result += "context: \(context) "
        }
        result += "dir: \(direction)"
        return result.trimmingSuffix(" ") + ")"
    }
}

// Protocol for observing changes to an MNTreeNode
public protocol MNTreeNodeObserver : Sendable {
    func nodeEvent(_ event: MNTreeNodeChange)
}

public protocol MNTreeNodeObservable {
    associatedtype ObserverType: MNTreeNodeObserver
    
    /*private (set)*/ var observers: ObserversArray<ObserverType> { get set }
    
    func addObservers(_ observers: [ObserverType])
    func removeObservers(_ observers: [ObserverType])
}

public extension MNTreeNodeObservable {
    func addObservers(_ observers: [ObserverType]) {
        self.observers.add(observers: observers)
    }
    
    func removeObservers(_ observers: [ObserverType]) {
        self.observers.remove(observers: observers)
    }
}

