//
//  Tree.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/30/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

public class TreeNode<T> {
    public var value: T
    
    public var parent: TreeNode?
    public var children = [TreeNode<T>]()
    
    public init(value: T) {
        self.value = value
    }
    
    public func addChild(_ node: TreeNode<T>) {
        children.append(node)
        node.parent = self
    }
}

extension TreeNode: CustomStringConvertible {
    public var description: String {
        var s = "\(value)"
        if !children.isEmpty {
            s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
        }
        return s
    }
}

extension TreeNode where T: Equatable {
    public func search(_ value: T) -> TreeNode? {
        if value == self.value {
            return self
        }
        for child in children {
            if let found = child.search(value) {
                return found
            }
        }
        return nil
    }
}

extension TreeNode {
    var count: Int { return _count() }
    var numberOfParents: Int { return _numberOfParents() }
    
    private func _count() -> Int {
        if children.isEmpty { return 1 }
        var currentIndex = 1
        for child in children { currentIndex += child._count() }
        return currentIndex
    }
    
    private func _numberOfParents() -> Int {
        var count = 0
        var grandParent: TreeNode<T>? = parent
        while grandParent != nil {
            count += 1
            grandParent = grandParent?.parent
        }
        return count
    }
}
