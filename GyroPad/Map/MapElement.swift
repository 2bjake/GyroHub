//
//  MapElement.swift
//  GyroPad
//
//  Created by Jake Foster on 6/28/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

enum MapElement: Character {
    case empty = "."
    case rope = "|"
    case ground = "Z"
    case greenPipe = "G"
    case character = "O"

    var tileGroup: SKTileGroup {
        switch self {
        case .rope:
            return TileProvider.tileGroupNamed(.rope)
        case .ground:
            return TileProvider.tileGroupNamed(.ground)
//        case .greenPipe:
//            return TileProvider.tileGroupNamed(.pipe)
        case .empty, .character, .greenPipe:
            return TileProvider.tileGroupNamed(.empty)
        }
    }
}
