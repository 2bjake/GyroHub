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

                let mapElement = MapElement(char)
                if case .character = mapElement {
                    characterCoords = coords
                    elements[coords] = .empty
                } else {
                    elements[coords] = mapElement
                }
            }
        }

        let numberOfColumns = lines[0].count
        let numberOfRows = lines.count
        let pipeConfigs = findPipesIn(elements, numberOfColumns: numberOfColumns, numberOfRows: numberOfRows)

        if let characterCoords = characterCoords {
            return MapConfig(numberOfColumns: numberOfColumns,
                             numberOfRows: numberOfRows,
                             elements: elements,
                             characterLocation: characterCoords,
                             pipeConfigs: pipeConfigs)
        } else {
            fatalError("no character position defined in the level data") //TODO: handle this gracefully
        }
    }

    private func findPipesIn(_ elements: [MapCoordinates: MapElement], numberOfColumns: Int, numberOfRows: Int) -> [PipeConfig] {
        //iterate through elements by column (bottom to top) to find pipes
        var pipeConfigs = [PipeConfig]()

        var currentPipe: (bottomCoords: MapCoordinates, color: UIColor)?

        for column in 0..<numberOfColumns {
            currentPipe = nil
            for row in 0..<numberOfRows {
                let currentCoords = MapCoordinates(column: column, row: row)
                let currentElement = elements[currentCoords]! // if we're missing a coord at this point, we've already screwed up pretty badly

                if let pipe = currentPipe, currentElement.pipeColor != pipe.color {
                    // left the top of the pipe, save coordinate
                    pipeConfigs.append((top: currentCoords.down, bottom: pipe.bottomCoords, color: pipe.color))
                    if let newColor = currentElement.pipeColor {
                        currentPipe = (currentCoords, newColor)
                    } else {
                        currentPipe = nil
                    }
                } else if case let .pipe(color) = currentElement, currentPipe == nil {
                    // found a new bottom pipe, set currentPipe
                    currentPipe = (currentCoords, color)
                }
            }

            // about to loop around to the next column, record the current pipe (if there is one)
            if let pipe = currentPipe {
                pipeConfigs.append((top: MapCoordinates(column: column, row: numberOfRows - 1), bottom: pipe.bottomCoords, color: pipe.color))
            }
        }
        return pipeConfigs
    }
}
