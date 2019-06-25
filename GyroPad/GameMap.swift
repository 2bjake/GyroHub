//
//  GameMap.swift
//  GyroPad
//
//  Created by Jake Foster on 6/25/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

//constants
private let isEdgeKey = "isEdge"
private let isClimbableKey = "isClimbable"

struct TileProperties {
    //TODO
}

class GameMap {
    struct Coordinates {
        var column: Int {
            didSet { if column < 0 { column = 0 } }
        }

        var row: Int {
            didSet { if row < 0 { row = 0 } }
        }
    }

    var tileMapNode: SKTileMapNode

    private var tileSize: CGSize { return tileMapNode.tileSize }
    private var halfTileWidth: CGFloat { return tileSize.width / 2 }
    private var halfTileHeight: CGFloat { return tileSize.height / 2 }

    init(tileMapNode: SKTileMapNode) {
        self.tileMapNode = tileMapNode

        for col in 0..<tileMapNode.numberOfColumns {
            for row in 0..<tileMapNode.numberOfRows {

                let tileDefinition = tileMapNode.tileDefinition(atColumn: col, row: row)

                if tileDefinition?.userData?[isEdgeKey] as? Bool ?? false {
                    makeEdgeNodeAt(column: col, row: row)
                }
            }
        }
    }

    func makeEdgeNodeAt(column: Int, row: Int ) {
        let centerPoint = tileMapNode.centerOfTile(atColumn: column, row: row)

        let tileNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height))
        tileNode.position = CGPoint(x: centerPoint.x - halfTileWidth, y: centerPoint.y - halfTileHeight)
        tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: halfTileWidth, y: halfTileHeight))
        tileNode.physicsBody?.linearDamping = 0.6
        tileNode.physicsBody?.restitution = 0.0
        tileNode.physicsBody?.isDynamic = false
        tileNode.physicsBody?.categoryBitMask = BitMask(.wall)
        tileNode.physicsBody?.contactTestBitMask = BitMask(.character)
        tileMapNode.addChild(tileNode)
    }

    func isRopeAtPoint(_ point: CGPoint) -> Bool {
        let coords = coordinatesforPoint(point)
        let definition = tileMapNode.tileDefinition(atColumn: coords.column, row: coords.row)
        return definition?.userData?[isClimbableKey] as? Bool ?? false
    }

    func coordinatesforPoint(_ point: CGPoint) -> Coordinates {
        let column = tileMapNode.tileColumnIndex(fromPosition: point)
        let row = tileMapNode.tileRowIndex(fromPosition: point)

        return Coordinates(column: column, row: row).clamped(tileMapNode: tileMapNode)
    }

    func pointFor(coordinates: Coordinates) -> CGPoint {
        var coordinates = coordinates.clamped(tileMapNode: tileMapNode)
        return tileMapNode.centerOfTile(atColumn: coordinates.column, row: coordinates.row)
    }

    func pointFor(column: Int, row: Int) -> CGPoint {
        return pointFor(coordinates: Coordinates(column: column, row: row))
    }

    func touchBegan(_ touch: UITouch) {
        let tilePosition = coordinatesforPoint(touch.location(in: tileMapNode))
        print("clicked at \(tilePosition)")
    }
}

extension GameMap.Coordinates {
    mutating func clamp(numberOfColumns: Int, numberOfRows: Int) {
        if column >= numberOfColumns { column = numberOfColumns - 1 }
        if row >= numberOfRows { row = numberOfRows - 1 }
    }

    func clamped(numberOfColumns: Int, numberOfRows: Int) -> GameMap.Coordinates {
        var copy = self
        copy.clamp(numberOfColumns: numberOfColumns, numberOfRows: numberOfRows)
        return copy
    }

    func clamped(tileMapNode: SKTileMapNode) -> GameMap.Coordinates {
        return self.clamped(numberOfColumns: tileMapNode.numberOfColumns, numberOfRows: tileMapNode.numberOfRows)
    }
}

