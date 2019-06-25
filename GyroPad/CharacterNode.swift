//
//  CharacterNode.swift
//  GyroPad
//
//  Created by Jake Foster on 6/24/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

class CharacterNode: SKShapeNode {
    private let movementSpeed = CGFloat(100)

    convenience init(size: CGSize) {
        self.init(circleOfRadius: size.width / 2)
        fillColor = .blue
        physicsBody = .init(circleOfRadius: size.width / 2)
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = BitMask(.character)
        physicsBody?.contactTestBitMask = BitMask(.wall)
    }

    public func update(deltaTime: TimeInterval, touchDirection: TouchDirection) {
        switch touchDirection {
        case .left:
            physicsBody?.velocity.dx = -movementSpeed
        case .right:
            physicsBody?.velocity.dx = movementSpeed
        default:
            physicsBody?.velocity.dx = 0
        }
    }
}
