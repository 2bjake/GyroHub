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
private let pipePositionKey = "pipePosition"



private enum RenderPercentages {
    static let groundHeight = 0.125
    static let pipeWidth = 0.7
    static let capHeight = 0.25
    static let capWidth = 0.9
    static let anchorHeight = 0.25
    static let anchorWidth = 0.12
}

enum PipePosition: Int {
    case top = 2
    case center = 1
    case bottom = 0
}

struct TileProperties {
    let isEdge: Bool
    let isClimbable: Bool
    let pipePosition: PipePosition?
    var isPipe: Bool { return pipePosition != nil }
}

extension TileProperties {
    static func at(column: Int, row: Int, in tileMapNode: SKTileMapNode) -> TileProperties {
        let tileDefinition = tileMapNode.tileDefinition(atColumn: column, row: row)

        func boolForKey(_ key: String) -> Bool {
            return tileDefinition?.userData?[key] as? Bool ?? false
        }

        func intForKey(_ key: String) -> Int? {
            return tileDefinition?.userData?[key] as? Int
        }

        let pipePosition: PipePosition? = {
            guard let positionValue = intForKey(pipePositionKey) else { return nil }
            return PipePosition(rawValue: positionValue)
        }()

        return TileProperties(isEdge: boolForKey(isEdgeKey),
                              isClimbable: boolForKey(isClimbableKey),
                              pipePosition: pipePosition)
    }

    static func at(coordinates: GameMap.Coordinates, in tileMapNode: SKTileMapNode) -> TileProperties {
        return .at(column: coordinates.column, row: coordinates.row, in: tileMapNode)
    }
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

    private let tileMapNode: SKTileMapNode

    private var tileSize: CGSize { return tileMapNode.tileSize }
    private var halfTileWidth: CGFloat { return tileSize.width / 2 }
    private var halfTileHeight: CGFloat { return tileSize.height / 2 }

    init(tileMapNode: SKTileMapNode) {
        self.tileMapNode = tileMapNode

        for column in 0..<tileMapNode.numberOfColumns {
            for row in 0..<tileMapNode.numberOfRows {
                let properties = TileProperties.at(column: column, row: row, in: tileMapNode)
                if properties.isEdge {
                    makeWallNodeAt(column: column, row: row)
                } else if let pipePosition = properties.pipePosition {
                    makePipeNodeAt(column: column, row: row, position: pipePosition)
                }
            }
        }
    }

    func makePipeNodeAt(column: Int, row: Int, position: PipePosition) {
        let centerPoint = tileMapNode.centerOfTile(atColumn: column, row: row)

        //TODO: these next 3 lines need to be customized for each pipe position
        let tileNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height))
        tileNode.position = CGPoint(x: centerPoint.x - halfTileWidth, y: centerPoint.y - halfTileHeight)
        tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: halfTileWidth, y: halfTileHeight))

        tileNode.physicsBody?.linearDamping = 0.6
        tileNode.physicsBody?.restitution = 0.0
        tileNode.physicsBody?.isDynamic = false
        tileNode.physicsBody?.categoryBitMask = BitMask(.pipe)
        tileNode.physicsBody?.contactTestBitMask = BitMask(.character | .wall)
        tileMapNode.addChild(tileNode)
    }

    func makeWallNodeAt(column: Int, row: Int) {
        let centerPoint = tileMapNode.centerOfTile(atColumn: column, row: row)

        let tileNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height))
        tileNode.position = CGPoint(x: centerPoint.x - halfTileWidth, y: centerPoint.y - halfTileHeight)
        tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: halfTileWidth, y: halfTileHeight))
        tileNode.physicsBody?.linearDamping = 0.6
        tileNode.physicsBody?.restitution = 0.0
        tileNode.physicsBody?.isDynamic = false
        tileNode.physicsBody?.categoryBitMask = BitMask(.wall)
        tileNode.physicsBody?.contactTestBitMask = BitMask(.character | .pipe)
        tileMapNode.addChild(tileNode)
    }

    func isRopeAtPoint(_ point: CGPoint) -> Bool { // TODO: consider renaming, this could also be ladders at some point...
        return TileProperties.at(coordinates: coordinatesforPoint(point), in: tileMapNode).isClimbable
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

