//
//  GameMap.swift
//  GyroPad
//
//  Created by Jake Foster on 6/25/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

private enum RenderPercentages {
    static let groundHeight = CGFloat(0.125)
    static let pipeWidth = CGFloat(0.7)
    static let capHeight = CGFloat(0.25)
    static let capWidth = CGFloat(0.9)
    static let anchorHeight = CGFloat(0.25)
    static let anchorWidth = CGFloat(0.12)
}

//TODO: this needs to more than just a wrapper around the tileMapNode.
// it also needs to model all of the (initial?) positions of game elements
// that are not part of the tilemap such as: character, smicks, pipes, coins, door(?)
class GameMap {
    private let tileMapNode: SKTileMapNode

    init(tileMapNode: SKTileMapNode) {
        self.tileMapNode = tileMapNode

        var pipeTopLocations = [MapCoordinates]()
        for column in 0..<tileMapNode.numberOfColumns {
            for row in 0..<tileMapNode.numberOfRows {
                let properties = TileProperties.at(column: column, row: row, in: tileMapNode)
                if properties.isEdge {
                    makeWallNodeAt(column: column, row: row)
                } else if properties.pipePart == .top {
                    pipeTopLocations.append(MapCoordinates(column: column, row: row))
                }
            }
        }
        pipeTopLocations.forEach(makePipeAt)
    }

    private func makePipeAt(_ coordinates: MapCoordinates) {
        print("pipe top at \(coordinates)")
        makePipePart(.top, at: coordinates)

        var curCoordinates = coordinates.down

        func isBottom() -> Bool {
            let properties = TileProperties.at(coordinates: curCoordinates, in: tileMapNode)
            return properties.pipePart == .bottom
        }

        while !isBottom() {
            print("pipe center at \(curCoordinates)")
            makePipePart(.center, at: curCoordinates)
            curCoordinates = curCoordinates.down
        }
        print("pipe bottom at \(curCoordinates)")
        makePipePart(.bottom, at: curCoordinates)
    }

    private func makePipePart(_ part: PipePart, at coordinates: MapCoordinates) {
        let tileSize = tileMapNode.tileSize
        let halfTileWidth = CGFloat(tileSize.width / 2)
        let halfTileHeight = CGFloat(tileSize.height / 2)

        let centerPoint = tileMapNode.centerOfTile(atColumn: coordinates.column, row: coordinates.row)
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
        tileNode.physicsBody?.contactTestBitMask = BitMask(.character | .wall)
        tileMapNode.addChild(tileNode)
    }

    private func makeWallNodeAt(column: Int, row: Int) {
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
        tileNode.physicsBody?.categoryBitMask = BitMask(.wall)
        tileNode.physicsBody?.contactTestBitMask = BitMask(.character | .pipe)
        tileMapNode.addChild(tileNode)
    }

    func isRopeAtPoint(_ point: CGPoint) -> Bool { // TODO: consider renaming, this could also be ladders at some point...
        return TileProperties.at(coordinates: coordinatesForPoint(point), in: tileMapNode).isClimbable
    }

    func touchBegan(_ touch: UITouch) {
        let tilePosition = coordinatesForPoint(touch.location(in: tileMapNode))
        print("clicked at \(tilePosition)")
    }
}

// helpers for converting coordinates to/from points
extension GameMap {
    func coordinatesForPoint(_ point: CGPoint) -> MapCoordinates {
        let column = tileMapNode.tileColumnIndex(fromPosition: point)
        let row = tileMapNode.tileRowIndex(fromPosition: point)

        return MapCoordinates(column: column, row: row).clamped(tileMapNode: tileMapNode)
    }

    func pointFor(coordinates: MapCoordinates) -> CGPoint {
        var coordinates = coordinates.clamped(tileMapNode: tileMapNode)
        return tileMapNode.centerOfTile(atColumn: coordinates.column, row: coordinates.row)
    }

    func pointFor(column: Int, row: Int) -> CGPoint {
        return pointFor(coordinates: MapCoordinates(column: column, row: row))
    }
}
