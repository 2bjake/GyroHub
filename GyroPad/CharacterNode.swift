//
//  CharacterNode.swift
//  GyroPad
//
//  Created by Jake Foster on 6/24/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

// constants
private let buffer = CGFloat(5)
private let movementSpeed = CGFloat(100)

class CharacterNode: SKShapeNode {
    convenience init(size: CGSize) {
        let radius = size.width / 2 - buffer
        self.init(circleOfRadius: radius)
        fillColor = .blue
        physicsBody = .init(circleOfRadius: radius)
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = BitMask(.character)
        physicsBody?.contactTestBitMask = BitMask(.wall)
    }

    public func update(deltaTime: TimeInterval, touchDirection: TouchDirection, isAtRope: Bool) {
        if isAtRope {
            physicsBody?.affectedByGravity = false
            physicsBody?.velocity.dy = 0
        } else {
            physicsBody?.affectedByGravity = true
        }


        switch touchDirection {
        case .left:
            physicsBody?.velocity.dx = -movementSpeed
        case .right:
            physicsBody?.velocity.dx = movementSpeed
        case .up:
            if isAtRope { physicsBody?.velocity = CGVector(dx: 0, dy: -movementSpeed) }
        case .down:
            if isAtRope { physicsBody?.velocity = CGVector(dx: 0, dy: movementSpeed) }
        case .none:
            physicsBody?.velocity.dx = 0
        }
    }
}
