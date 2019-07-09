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

    private let levelReader = LevelReader()
    private var levelMap: LevelMap! // always set in sceneDidLoad()

    // for tracking movement touches
    private var touchStartPosition: CGPoint?
    private var touchCurrentPosition: CGPoint?

    private var currentTouchDirection: TouchDirection {
        return .directionFor(start: touchStartPosition, current: touchCurrentPosition)
    }

    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        let mapConfig = levelReader.mapConfigFor("simple") //TODO
        levelMap = LevelMapBuilder(config: mapConfig).buildMap()
    }

    override func didMove(to view: SKView) {
        addChild(levelMap)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }

        let dt = currentTime - lastUpdateTime

        levelMap.update(deltaTime: dt, touchDirection: currentTouchDirection)
        lastUpdateTime = currentTime
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStartPosition = touch.location(in: self)
        levelMap.touchBegan(touch)
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
        //print("contact between \(contact.bodyA.category) and \(contact.bodyB.category)")
    }
}
