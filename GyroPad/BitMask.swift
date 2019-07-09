//
//  BitMask.swift
//  GyroPad
//
//  Created by Jake Foster on 6/25/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

typealias BitMask = UInt32

extension BitMask {
    init(shift: Int) {
        self = 0x1 << shift
    }
}

extension SKPhysicsBody {
    func isCategory(_ category: BitMask) -> Bool {
        return categoryBitMask == category
    }
}

extension SKPhysicsContact {
    func hasCategory(_ category: BitMask) -> Bool {
        return mainBodyAs(category) != nil
    }

    func mainBodyAs(_ category: BitMask) -> (main: SKPhysicsBody, other: SKPhysicsBody)? {
        if bodyA.isCategory(category) {
            return (bodyA, bodyB)
        } else if bodyB.isCategory(category) {
            return (bodyB, bodyA)
        } else {
            return nil
        }
    }

    func firstBodyAs(_ category: BitMask) -> SKPhysicsBody? {
        if let (main, _) = mainBodyAs(category) {
            return main
        } else {
            return nil
        }
    }
}
