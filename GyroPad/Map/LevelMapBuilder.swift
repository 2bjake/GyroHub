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

    private enum RenderPercentages {
//      static let groundHeight = CGFloat(0.125)
        static let pipeWidth = CGFloat(0.7)
        static let capHeight = CGFloat(0.25)
        static let capWidth = CGFloat(0.9)
//      static let anchorHeight = CGFloat(0.25)
//      static let anchorWidth = CGFloat(0.12)
    }

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

        // temporary hack, have to draw pipes only first, then everything else to make it render correctly
        for row in 0..<config.numberOfRows {
            for column in 0..<config.numberOfColumns {
                let element = config.elementAt(column: column, row: row)
                if element == .greenPipe {
                    tileMapNode.setTileGroup(element.tileGroup, forColumn: column, row: row)
                }
            }
        }
        config.pipeLocations.forEach(makePipeNodes)

        for row in 0..<config.numberOfRows {
            for column in 0..<config.numberOfColumns {
                let element = config.elementAt(column: column, row: row)
                if element != .greenPipe {
                    tileMapNode.setTileGroup(element.tileGroup, forColumn: column, row: row)
                }

                if element == .ground {
                    makeGroundNodeAt(column: column, row: row)
                }
            }
        }

        let character = CharacterNode(size: tileSize)
        character.position = tileMapNode.centerOfTile(atCoordinates: config.characterLocation)

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

    private func makePipeNodes(_ location: PipeLocation) {
        makePipePart(.top, at: location.top)
        var currentLocation = location.top.down

        while currentLocation != location.bottom {
            makePipePart(.center, at: currentLocation)
            currentLocation = currentLocation.down
        }
        makePipePart(.bottom, at: currentLocation)
    }

    private func makePipePart(_ part: PipePart, at coordinates: MapCoordinates) {
        let tileSize = tileMapNode.tileSize
        let halfTileWidth = CGFloat(tileSize.width / 2)
        let halfTileHeight = CGFloat(tileSize.height / 2)

        let centerPoint = tileMapNode.centerOfTile(atCoordinates: coordinates)
        let size: CGSize
        let yPosition: CGFloat

        switch part {
        case .top:
            size = CGSize(width: tileSize.width, height: tileSize.height * RenderPercentages.capHeight)
            yPosition = centerPoint.y - halfTileHeight
        case .center:
            size = tileSize
            yPosition = centerPoint.y - halfTileHeight
        case .bottom:
            size = CGSize(width: tileSize.width, height: tileSize.height * RenderPercentages.capHeight)
            yPosition = centerPoint.y + halfTileHeight - size.height
        }

        let tileNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        tileNode.position = CGPoint(x: centerPoint.x - halfTileWidth, y: yPosition)
        tileNode.physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: size.width / 2, y: size.height / 2))

        tileNode.physicsBody?.linearDamping = 0.6
        tileNode.physicsBody?.restitution = 0.0
        tileNode.physicsBody?.isDynamic = false
        tileNode.physicsBody?.categoryBitMask = BitMask(.pipe)
        tileNode.physicsBody?.contactTestBitMask = BitMask(.character | .ground)
        tileMapNode.addChild(tileNode)
    }
}
