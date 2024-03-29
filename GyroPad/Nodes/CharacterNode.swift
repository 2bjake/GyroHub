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
private let movementSpeed = CGFloat(200)

class CharacterNode: SKShapeNode {

    convenience init(size: CGSize) { //TODO: fix this so that it's the only init
        let radius = size.width / 5
        self.init(circleOfRadius: radius)
        fillColor = .orange
        physicsBody = .init(circleOfRadius: radius)
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = .character
        physicsBody?.contactTestBitMask = .ground
        physicsBody?.fieldBitMask = 0
        physicsBody?.isDynamic = true
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
