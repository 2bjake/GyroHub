//
//  BitMask+GyroPad.swift
//  GyroPad
//
//  Created by Jake Foster on 6/27/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

extension BitMask {
    static let character = BitMask(shift: 1)
    static let ground = BitMask(shift: 2)
    static let redPipe = BitMask(shift: 3)
    static let bluePipe = BitMask(shift: 4)
    static let allPipes = .redPipe | .bluePipe
    static let redPipeField = BitMask(shift: 5)
    static let bluePipeField = BitMask(shift: 6)
}

extension BitMask {
    var categoryName: String {
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
            return "unknown (\(self))"
        }
    }
}
