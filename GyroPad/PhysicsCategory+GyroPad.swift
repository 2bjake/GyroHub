//
//  PhysicsCategory+GyroPad.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

extension PhysicsCategory {
    static let character = PhysicsCategory(shift: 1)
    static let ground = PhysicsCategory(shift: 2)
    static let redPipe = PhysicsCategory(shift: 3)
    static let bluePipe = PhysicsCategory(shift: 4)
    static let allPipes = .redPipe | .bluePipe
    static let redPipeField = PhysicsCategory(shift: 5)
    static let bluePipeField = PhysicsCategory(shift: 6)

}

extension PhysicsCategory: CustomStringConvertible {
    var description: String {
        switch self {
        case .character:
            return "character"
        case .ground:
            return "ground"
        case .redPipe:
            return "redPipe"
        case .bluePipe:
            return "bluePipe"
        default:
            return String(bitMask)
        }
    }
}
