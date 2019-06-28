//
//  LevelReader.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

class LevelReader {
    func mapConfigFor(_ levelAssetName: String) -> MapConfig {
        guard let levelAsset = NSDataAsset(name: levelAssetName, bundle: Bundle(for: type(of: self))),
            let levelString = String(data: levelAsset.data, encoding: .utf8) else {
                fatalError("could not retrieve level data with name \(levelAssetName)")
        }

        var characterCoords: MapCoordinates?
        var elements = [MapCoordinates: MapElement]()

        let lines = levelString.split(separator: "\n")

        lines.enumerated().forEach { lineIndex, line in
            guard lines[lineIndex].count == lines[0].count else {
                fatalError("line \(lineIndex) length (\(lines[lineIndex].count)) does not match line 0 length (\(lines[0].count))")
            }
            line.enumerated().forEach { charIndex, char in
                let row = lines.count - lineIndex - 1
                let column = charIndex
                let coords = MapCoordinates(column: column, row: row)

                guard let mapElement = MapElement(rawValue: char) else {
                    fatalError("no map element found for value \(char)") //TODO: handle this gracefully
                }

                if mapElement == .character {
                    characterCoords = coords
                    elements[coords] = .empty
                } else {
                    elements[coords] = mapElement
                }
            }
        }

        let pipeLocations = findPipeLocationsIn(elements, numberOfColumns: lines[0].count, numberOfRows: lines.count)

        if let characterCoords = characterCoords {
            return MapConfig(elements: elements, characterLocation: characterCoords, pipeLocations: pipeLocations)
        } else {
            fatalError("no character position defined in the level data") //TODO: handle this gracefully
        }
    }

    private func findPipeLocationsIn(_ elements: [MapCoordinates: MapElement], numberOfColumns: Int, numberOfRows: Int) -> [(top: MapCoordinates, bottom: MapCoordinates)] {
        //iterate through elements by column (top to bottom) to find pipes
        var pipeLocations = [(top: MapCoordinates, bottom: MapCoordinates)]()

        var currentPipeBottomCoords: MapCoordinates?
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let currentCoords = MapCoordinates(column: column, row: row)
                let currentElement = elements[currentCoords]! // if we're missing a coord at this point, we've already screwed up pretty badly

                if let bottomCoord = currentPipeBottomCoords, currentElement != .greenPipe {
                    // left the top of the pipe, save coordinate
                    pipeLocations.append((top: currentCoords.down, bottom: bottomCoord))
                    currentPipeBottomCoords = nil
                } else if currentPipeBottomCoords == nil && currentElement == .greenPipe {
                    // found a new bottom pipe, set currentPipeBottomCoords
                    currentPipeBottomCoords = currentCoords
                }
            }
        }
        return pipeLocations
    }
}
