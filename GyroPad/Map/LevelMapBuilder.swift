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

                if element == .ground {
                    makeGroundNodeAt(column: column, row: row)
                }
            }
        }

        let character = CharacterNode(size: tileSize)
        character.position = tileMapNode.centerOfTile(atCoordinates: config.characterLocation)

        makePipes(config.pipeLocations).forEach {
            tileMapNode.addChild($0)
        }

        tileMapNode.addChild(character)



        return LevelMap(config: config, tileMapNode: tileMapNode, character: character)
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

    private func makePipes(_ locations: [PipeLocation]) -> [PipeNode] {
        return locations.map {
            let pipe = PipeNode.makePipe(size: tileSize, length: $0.top.row - $0.bottom.row + 1)
            pipe.position = tileMapNode.centerOfTile(atCoordinates: $0.top)
            return pipe
        }
    }
}
