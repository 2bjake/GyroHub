//
//  TileProvider.swift
//  GyroPad
//
//  Created by Jake Foster on 6/28/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

enum TileProvider {
    enum TileGroupName: String {
        case rope = "Rope"
        case ground = "Ground"
        case pipe = "Pipe"
        case empty = "Empty"
    }

    static var tileSet: SKTileSet {
        guard let tileSet = SKTileSet(named: "GyroTileSet") else {
            fatalError("could not load tileSet")
        }
        return tileSet
    }

    static func tileGroupNamed(_ name: TileGroupName) -> SKTileGroup {
        guard let tileGroup = tileSet.tileGroups.first(where: { $0.name == name.rawValue }) else {
            fatalError("could not load tileGroup with name \(name)")
        }
        return tileGroup
    }
}
