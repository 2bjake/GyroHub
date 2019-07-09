//
//  LevelMap.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

//constants
private let isGroundKey = "isGround"
private let isClimbableKey = "isClimbable"

extension SKTileDefinition {
    func boolForKey(_ key: String) -> Bool {
        return userData?[key] as? Bool ?? false
    }

    func intForKey(_ key: String) -> Int? {
        return userData?[key] as? Int
    }
}

private struct TileProperties {
    let isGround: Bool
    let isClimbable: Bool
}

extension TileProperties {
    init(_ definition: SKTileDefinition?) {
        guard let definition = definition else {
            self.init(isGround: false, isClimbable: false)
            return
        }
        self.init(isGround: definition.boolForKey(isGroundKey), isClimbable: definition.boolForKey(isClimbableKey))
    }
}

class LevelMap: SKNode {

    private let config: MapConfig
    private let tileMapNode: SKTileMapNode
    private let character: CharacterNode
    private let pipes: [PipeNode]
    private let pipeFields: [UIColor: SKFieldNode]

    private var characterCoords: MapCoordinates {
        return coordinatesForPoint(character.position)
    }

    private var isCharacterAtRope: Bool {
        let properties = TileProperties(tileMapNode.tileDefinition(atCoordinates: characterCoords))
        return properties.isClimbable
    }

    init(config: MapConfig, tileMapNode: SKTileMapNode, character: CharacterNode, pipes: [PipeNode], pipeFields: [UIColor: SKFieldNode]) {
        self.config = config
        self.tileMapNode = tileMapNode
        self.character = character
        self.pipes = pipes
        self.pipeFields = pipeFields
        super.init()

        addChild(tileMapNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let pipeSwitchTime = TimeInterval(2)
    var timeSincePipeSwitch = TimeInterval(0)
    func update(deltaTime: TimeInterval, touchDirection: TouchDirection) {
        character.update(deltaTime: deltaTime, touchDirection: touchDirection, isAtRope: isCharacterAtRope)
        timeSincePipeSwitch += deltaTime
        if timeSincePipeSwitch >= pipeSwitchTime {
            timeSincePipeSwitch = 0
            pipeFields[.red]?.isEnabled.toggle()
            pipeFields[.blue]?.isEnabled = !pipeFields[.red]!.isEnabled
        }
    }

    func touchBegan(_ touch: UITouch) {
        let tilePosition = coordinatesForPoint(touch.location(in: tileMapNode))
        print("clicked at \(tilePosition)")
    }
}

// helpers for converting coordinates to/from points
extension LevelMap {
    private func coordinatesForPoint(_ point: CGPoint) -> MapCoordinates {
        let column = tileMapNode.tileColumnIndex(fromPosition: point)
        let row = tileMapNode.tileRowIndex(fromPosition: point)
        return MapCoordinates(column: column, row: row).clamped(tileMapNode: tileMapNode)
    }

    private func pointFor(coordinates: MapCoordinates) -> CGPoint {
        let coordinates = coordinates.clamped(tileMapNode: tileMapNode)
        return tileMapNode.centerOfTile(atCoordinates: coordinates)
    }

    private func pointFor(column: Int, row: Int) -> CGPoint {
        return pointFor(coordinates: MapCoordinates(column: column, row: row))
    }
}
