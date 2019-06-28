//
//  MapConfig.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import Foundation

struct MapConfig {
    let elements: [MapCoordinates: MapElement]
    let characterLocation: MapCoordinates
    let pipeLocations: [(top: MapCoordinates, bottom: MapCoordinates)]
}
