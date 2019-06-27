//
//  MapWriter.swift
//  GyroPad
//
//  Created by Jake Foster on 6/26/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

enum MapElement: Character {
    case empty = "."
    case rope = "|"
    case ground = "I"
    case greenPipe = "G"

    var tileGroup: SKTileGroup? {
        guard let tileSet = SKTileSet(named: "GyroTileSet") else {
            fatalError("could not load tileSet")
        }
        switch self {
        case .rope:
            return tileSet.tileGroups.first { $0.name == "Rope" }
        case .ground:
            return tileSet.tileGroups.first { $0.name == "Ground" }
        case .greenPipe:
            return tileSet.tileGroups.first { $0.name == "Pipe" }
        default:
            return nil
        }
    }
}

class MapWriter {
    func drawMap(_ tileMapNode: SKTileMapNode) { //TODO: take asset name as param
        tileMapNode.enableAutomapping = true

        guard let mapAsset = NSDataAsset(name: "simple", bundle: Bundle(for: type(of: self))),
            let mapString = String(data: mapAsset.data, encoding: .utf8) else {
                fatalError("could not retrieve map data")
        }

        mapString.split(separator: "\n").enumerated().forEach { lineIndex, line in
            line.enumerated().forEach { charIndex, char in
                let tileGroup = MapElement(rawValue: char)?.tileGroup
                let row = tileMapNode.numberOfRows - 1 - lineIndex
                let column = charIndex
                if let tileGroup = tileGroup, tileGroup.name == "Pipe" {
                    tileMapNode.setTileGroup(tileGroup, forColumn: column, row: row)
                }
                print("(row: \(row), column: \(column)) = \(tileGroup?.name ?? "none")")
            }
        }

        //HACK: pipes have to be drawn first else map gets screwed up
        mapString.split(separator: "\n").enumerated().forEach { lineIndex, line in
            line.enumerated().forEach { charIndex, char in
                let tileGroup = MapElement(rawValue: char)?.tileGroup
                let row = tileMapNode.numberOfRows - 1 - lineIndex
                let column = charIndex
                if let tileGroup = tileGroup, tileGroup.name != "Pipe" {
                    tileMapNode.setTileGroup(tileGroup, forColumn: column, row: row)
                }
                print("(row: \(row), column: \(column)) = \(tileGroup?.name ?? "none")")
            }
        }
    }
}
