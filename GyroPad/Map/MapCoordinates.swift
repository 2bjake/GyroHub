//
//  MapCoordinates.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

struct MapCoordinates {
    var column: Int { didSet { column = max(0, column) }}
    var row: Int { didSet { row = max(row, 0) }}
}

extension MapCoordinates {
    mutating func clamp(numberOfColumns: Int, numberOfRows: Int) {
        if column >= numberOfColumns { column = numberOfColumns - 1 }
        if row >= numberOfRows { row = numberOfRows - 1 }
    }

    func clamped(numberOfColumns: Int, numberOfRows: Int) -> MapCoordinates {
        var copy = self
        copy.clamp(numberOfColumns: numberOfColumns, numberOfRows: numberOfRows)
        return copy
    }

    func clamped(tileMapNode: SKTileMapNode) -> MapCoordinates {
        return clamped(numberOfColumns: tileMapNode.numberOfColumns, numberOfRows: tileMapNode.numberOfRows)
    }
}

extension MapCoordinates {
    var up: MapCoordinates { return .init(column: column, row: row + 1) }
    var down: MapCoordinates { return .init(column: column, row: row - 1) }
    var left: MapCoordinates { return .init(column: column - 1, row: row) }
    var right: MapCoordinates { return .init(column: column + 1, row: row) }
}

