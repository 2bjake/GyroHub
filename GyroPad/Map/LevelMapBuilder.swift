//
//  LevelMapBuilder.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

class LevelMapBuilder {

    private let tileSize = CGSize(width: 50, height: 50)
    let config: MapConfig
    var tileMapNode: SKTileMapNode!

    init(config: MapConfig) {
        self.config = config
    }

    func buildMap() -> LevelMap {
        tileMapNode = SKTileMapNode(tileSet: TileProvider.tileSet,
                                    columns: config.numberOfColumns,
                                    rows: config.numberOfRows,
                                    tileSize: tileSize,
                                    fillWith: TileProvider.tileGroupNamed(.empty))

        for row in 0..<config.numberOfRows {
            for column in 0..<config.numberOfColumns {
                let element = config.elementAt(column: column, row: row)
                tileMapNode.setTileGroup(element.tileGroup, forColumn: column, row: row)

                if case .ground = element {
                    makeGroundNodeAt(column: column, row: row)
                }
            }
        }

        let character = CharacterNode(size: tileSize)
        character.position = tileMapNode.centerOfTile(atCoordinates: config.characterLocation)

        let pipes = config.pipeConfigs.map(makePipe)
        pipes.forEach(tileMapNode.addChild)

        config.pipeConfigs.forEach {
            let (leftAnchor, rightAnchor) = makeAnchorsForPipe($0)
            tileMapNode.addChild(leftAnchor)
            tileMapNode.addChild(rightAnchor)
        }

        tileMapNode.addChild(character)

        return LevelMap(config: config, tileMapNode: tileMapNode, character: character, pipes: pipes)
    }

    private func makeGroundNodeAt(column: Int, row: Int) {
        let tileSize = tileMapNode.tileSize
        let halfTileWidth = CGFloat(tileSize.width / 2)
        let halfTileHeight = CGFloat(tileSize.height / 2)

        let centerPoint = tileMapNode.centerOfTile(atColumn: column, row: row)

        let tileNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height))
        tileNode.position = CGPoint(x: centerPoint.x - halfTileWidth, y: centerPoint.y - halfTileHeight)
        tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: halfTileWidth, y: halfTileHeight))

        tileNode.physicsBody?.linearDamping = 0.6
        tileNode.physicsBody?.restitution = 0.0
        tileNode.physicsBody?.isDynamic = false
        tileNode.physicsBody?.categoryBitMask = BitMask(.ground)
        tileNode.physicsBody?.contactTestBitMask = BitMask(.character | .pipe)
        tileMapNode.addChild(tileNode)
    }

    private func makePipe(_ config: PipeConfig) -> PipeNode {
        let length = config.top.row - config.bottom.row + 1
        let pipe = PipeNode.makePipe(length: length, color: config.color, size: tileSize)
        pipe.position = tileMapNode.centerOfTile(atCoordinates: config.top)
        return pipe
    }

    private func makeAnchorsForPipe(_ config: PipeConfig) -> (left: SKShapeNode, right: SKShapeNode) {
        let centerPoint = tileMapNode.centerOfTile(atCoordinates: config.bottom)

        let anchorWidth = tileSize.width * 0.15
        let anchorSize = CGSize(width: anchorWidth, height: tileSize.height * 0.5)

        let left = SKShapeNode(rectOf: anchorSize)
        left.fillColor = .gray
        left.position = CGPoint(x: centerPoint.x - tileSize.width / 2 + anchorWidth / 2, y: centerPoint.y)
        left.physicsBody = SKPhysicsBody(rectangleOf: anchorSize)
        left.physicsBody?.isDynamic = false

        let right = SKShapeNode(rectOf: anchorSize)
        right.fillColor = .gray
        right.position = CGPoint(x: centerPoint.x + tileSize.width / 2 - anchorWidth / 2, y: centerPoint.y)
        right.physicsBody = SKPhysicsBody(rectangleOf: anchorSize)
        right.physicsBody?.isDynamic = false

        return (left, right)
    }
}
