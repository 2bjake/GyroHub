//
//  GameMap.swift
//  GyroPad
//
//  Created by Jake Foster on 6/25/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit



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

//    init(tileMapNode: SKTileMapNode) {
//        self.tileMapNode = tileMapNode
//
//
//        let tileSize = tileMapNode.tileSize
//        let halfWidth = CGFloat(tileMapNode.numberOfColumns) / 2.0 * tileSize.width
//        let halfHeight = CGFloat(tileMapNode.numberOfRows) / 2.0 * tileSize.height
//
//        for col in 0..<tileMapNode.numberOfColumns {
//            for row in 0..<tileMapNode.numberOfRows {
//
//                let tileDefinition = tileMapNode.tileDefinition(atColumn: col, row: row)
//                let isEdgeTile = tileDefinition?.userData?["isEdge"] as? Bool ?? false
//
//                if isEdgeTile {
//                    let x = CGFloat(col) * tileSize.width - halfWidth
//                    let y = CGFloat(row) * tileSize.height - halfHeight
//                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
//                    let tileNode = SKShapeNode(rect: rect)
//                    tileNode.position = CGPoint(x: x, y: y)
//                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
//                    tileNode.physicsBody?.isDynamic = false
//                    //tileNode.physicsBody?.collisionBitMask = playerCollisionMask | wallCollisionMask
//                    //tileNode.physicsBody?.categoryBitMask = wallCollisionMask
//                    tileMapNode.addChild(tileNode)
//                }
//            }
//        }
//    }

    init(tileMapNode: SKTileMapNode) {
        self.tileMapNode = tileMapNode


        let tileSize = tileMapNode.tileSize
        let halfWidth = tileSize.width / 2.0
        let halfHeight = tileSize.height / 2.0

        for col in 0..<tileMapNode.numberOfColumns {
            for row in 0..<tileMapNode.numberOfRows {

                let tileDefinition = tileMapNode.tileDefinition(atColumn: col, row: row)
                let isEdgeTile = tileDefinition?.userData?["isEdge"] as? Bool ?? false

                if isEdgeTile {
                    let centerPoint = tileMapNode.centerOfTile(atColumn: col, row: row)

                    let tileNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height))
                    tileNode.position = CGPoint(x: centerPoint.x - halfWidth, y: centerPoint.y - halfHeight)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: halfWidth, y: halfHeight))
                    tileNode.physicsBody?.linearDamping = 0.6
                    tileNode.physicsBody?.restitution = 0.0
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.categoryBitMask = BitMask(.wall)
                    tileNode.physicsBody?.contactTestBitMask = BitMask(.character)
                    tileMapNode.addChild(tileNode)
                }
            }
        }
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

