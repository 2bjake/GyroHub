//
//  MapConfig.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

typealias PipeLocation = (top: MapCoordinates, bottom: MapCoordinates)

struct MapConfig {
    let numberOfColumns: Int
    let numberOfRows: Int
    let elements: [MapCoordinates: MapElement]
    let characterLocation: MapCoordinates
    let pipeLocations: [PipeLocation]
}

extension MapConfig {
    func elementAt(column: Int, row: Int) -> MapElement {
        let coords = MapCoordinates(column: column, row: row).clamped(numberOfColumns: numberOfColumns, numberOfRows: numberOfRows)
        return elements[coords]! // safe since coord has been clamped to bounds
    }
}
