//
//  TileProperties.swift
//  GyroPad
//
//  Created by Jake Foster on 6/26/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

//constants
private let isEdgeKey = "isEdge"
private let isClimbableKey = "isClimbable"
private let pipePartKey = "pipePart"

enum PipePart: Int {
    case top = 2
    case center = 1
    case bottom = 0
}

struct TileProperties {
    let isEdge: Bool
    let isClimbable: Bool
    let pipePart: PipePart?
    var isPipe: Bool { return pipePart != nil }
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

        let pipePart: PipePart? = {
            guard let positionValue = intForKey(pipePartKey) else { return nil }
            return PipePart(rawValue: positionValue)
        }()

        return TileProperties(isEdge: boolForKey(isEdgeKey),
                              isClimbable: boolForKey(isClimbableKey),
                              pipePart: pipePart)
    }

    static func at(coordinates: GameMap.Coordinates, in tileMapNode: SKTileMapNode) -> TileProperties {
        return .at(column: coordinates.column, row: coordinates.row, in: tileMapNode)
    }
}

