//
//  MapElement.swift
//  GyroPad
//
//  Created by Jake Foster on 6/28/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

enum MapElement {
    case empty
    case rope
    case ground
    case pipe(UIColor)
    case character

    init(_ char: Character) {
        switch char {
        case ".":
            self = .empty
        case "|":
            self = .rope
        case "Z":
            self = .ground
        case "B":
            self = .pipe(.blue)
        case "O":
            self = .character
        default:
            self = .empty
        }
    }

    var isPipe: Bool {
        if case .pipe = self {
            return true
        }
        return false
    }

    var tileGroup: SKTileGroup {
        switch self {
        case .rope:
            return TileProvider.tileGroupNamed(.rope)
        case .ground:
            return TileProvider.tileGroupNamed(.ground)
        case .empty, .character, .pipe:
            return TileProvider.tileGroupNamed(.empty)
        }
    }
}
