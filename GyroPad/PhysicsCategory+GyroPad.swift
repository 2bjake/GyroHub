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
    static let pipe = PhysicsCategory(shift: 3)
}

extension PhysicsCategory: CustomStringConvertible {
    var description: String {
        switch self {
        case .character:
            return "character"
        case .ground:
            return "ground"
        case .pipe:
            return "pipe"
        default:
            return String(bitMask)
        }
    }
}
