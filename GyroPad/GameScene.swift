//
//  GameScene.swift
//  GyroPad
//
//  Created by Jake Foster on 6/24/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var characterNode = CharacterNode(size: .init(width: 50, height: 50))
    var tileMapNode: SKTileMapNode!

    override func sceneDidLoad() {
        for child in children {
            if let node = child as? SKTileMapNode {
                tileMapNode = node
                break
            }

        }
    }

    override func didMove(to view: SKView) {
        characterNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(characterNode)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    private func inBoundsTileCoordforPoint(_ point: CGPoint) -> (row: Int, col: Int) {
        var col = tileMapNode.tileColumnIndex(fromPosition: point)
                if col < 0 { col = 0 }
                if col >= tileMapNode.numberOfColumns { col = tileMapNode.numberOfColumns - 1 }

        var row = tileMapNode.tileRowIndex(fromPosition: point)
                if row < 0 { row = 0 }
                if row >= tileMapNode.numberOfRows { row = tileMapNode.numberOfRows - 1 }

        return (row, col)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tilePosition = inBoundsTileCoordforPoint(touch.location(in: tileMapNode))
        if let definition = tileMapNode.tileDefinition(atColumn: tilePosition.col, row: tilePosition.row),
            let isEdge = definition.userData?.value(forKey: "isEdge") as? Bool {
            // TODO: don't move here, this is a wall...
            return
        }
        let newPosition = tileMapNode.centerOfTile(atColumn: tilePosition.col, row: tilePosition.row)
        characterNode.run(.move(to: newPosition, duration: 1))

    }
}
