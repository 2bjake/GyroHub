//
//  MapBuilder.swift
//  GyroPad
//
//  Created by Jake Foster on 6/26/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

enum TileGroupName: String {
    case rope = "Rope"
    case ground = "Ground"
    case pipe = "Pipe"
    case empty = "Empty"
}

extension SKTileSet {
    func tileGroupNamed(_ name: TileGroupName) -> SKTileGroup? {
        return tileGroups.first { $0.name == name.rawValue }
    }
}

enum MapElement: Character {
    case empty = "."
    case rope = "|"
    case ground = "Z"
    case greenPipe = "G"
    case character = "O"

    var tileGroup: SKTileGroup? {
        guard let tileSet = SKTileSet(named: "GyroTileSet") else {
            fatalError("could not load tileSet")
        }
        switch self {
        case .rope:
            return tileSet.tileGroupNamed(.rope)
        case .ground:
            return tileSet.tileGroupNamed(.ground)
        case .greenPipe:
            return tileSet.tileGroupNamed(.pipe)
        default:
            return nil
        }
    }
}

class MapBuilder {
    func buildMap(tileSet: SKTileSet) -> GameMap {
        let tileMapNode = SKTileMapNode(tileSet: tileSet, columns: 20, rows: 15, tileSize: CGSize(width: 50, height: 50))
        tileMapNode.enableAutomapping = true

        guard let mapAsset = NSDataAsset(name: "simple", bundle: Bundle(for: type(of: self))),
            let mapString = String(data: mapAsset.data, encoding: .utf8) else {
                fatalError("could not retrieve map data")
        }

        var characterCoords: MapCoordinates?

        mapString.split(separator: "\n").enumerated().forEach { lineIndex, line in
            line.enumerated().forEach { charIndex, char in
                let row = tileMapNode.numberOfRows - 1 - lineIndex
                let column = charIndex

                if char == MapElement.character.rawValue {
                    characterCoords = MapCoordinates(column: column, row: row)
                }

                if let tileGroup = MapElement(rawValue: char)?.tileGroup, tileGroup.name == TileGroupName.pipe.rawValue {
                    tileMapNode.setTileGroup(tileGroup, forColumn: column, row: row)
                    //print("(row: \(row), column: \(column)) = \(tileGroup.name ?? "none")")
                }

            }
        }

        //HACK: pipes have to be drawn first else map gets screwed up
        mapString.split(separator: "\n").enumerated().forEach { lineIndex, line in
            line.enumerated().forEach { charIndex, char in
                let row = tileMapNode.numberOfRows - 1 - lineIndex
                let column = charIndex

                if let tileGroup = MapElement(rawValue: char)?.tileGroup, tileGroup.name != TileGroupName.pipe.rawValue {
                    tileMapNode.setTileGroup(tileGroup, forColumn: column, row: row)
                    //print("(row: \(row), column: \(column)) = \(tileGroup.name ?? "none")")
                }
            }
        }

        if let characterCoords = characterCoords {
            return GameMap(initialCharacterCoords: characterCoords, tileMapNode: tileMapNode)
        } else {
            fatalError("character location not specified in level") //TODO: handle this gracefully
        }
    }
}
