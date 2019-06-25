//
//  GameScene.swift
//  GyroPad
//
//  Created by Jake Foster on 6/24/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit
import GameplayKit

enum TouchDirection {
    case up, down, left, right, none

    static func directionFor(start: CGPoint?, current: CGPoint?) -> TouchDirection {
        guard let start = start, let current = current else { return .none }

        let xDiff = current.x - start.x
        let yDiff = current.y - start.y

        if abs(xDiff) > abs(yDiff) {
            return xDiff < 0 ? .left : .right
        } else {
            return yDiff < 0 ? .up : .down
        }
    }
}

class GameScene: SKScene {
    private var lastUpdateTime = TimeInterval(0)

    private var characterNode = CharacterNode(size: .init(width: 50, height: 50))
    private lazy var tileMapNode = childNode(withName: "TileMap") as! SKTileMapNode
    private lazy var map = GameMap(tileMapNode: tileMapNode)

    // for tracking movement touches
    private var touchStartPosition: CGPoint?
    private var touchCurrentPosition: CGPoint?

    private var currentTouchDirection: TouchDirection {
        return .directionFor(start: touchStartPosition, current: touchCurrentPosition)
    }

    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
    }

    override func didMove(to view: SKView) {
        //characterNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        characterNode.position = map.pointFor(column: 9, row: 13)
        addChild(characterNode)
    }

    override func update(_ currentTime: TimeInterval) {

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        characterNode.update(deltaTime: dt, touchDirection: currentTouchDirection, isAtRope: map.isRopeAtPoint(characterNode.position))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStartPosition = touch.location(in: self)

        map.touchBegan(touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchCurrentPosition = touch.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchStartPosition = nil
        touchCurrentPosition = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchStartPosition = nil
        touchCurrentPosition = nil
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact between \(contact.bodyA.category) and \(contact.bodyB.category)")
    }
}
