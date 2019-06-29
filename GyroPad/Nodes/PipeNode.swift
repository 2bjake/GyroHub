//
//  PipeNode.swift
//  GyroPad
//
//  Created by Jake Foster on 6/28/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

class PipeNode: SKNode {
    private override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// maker
extension PipeNode {
    static private let centerTexture = SKTexture(imageNamed: "Pipe_Center")
    static private let topTexture = SKTexture(imageNamed: "Pipe_Top")
    static private let bottomTexture = SKTexture(imageNamed: "Pipe_Bottom")
    static private let singleTexture = SKTexture(imageNamed: "Pipe_Single")

    static func makeColorizedNode(texture: SKTexture, color: UIColor, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(texture: texture, color: color, size: size)
        node.colorBlendFactor = 0.75
        return node
    }

    static func makePipe(length: Int, color: UIColor, size: CGSize) -> PipeNode {
        let pipeNode = PipeNode()

        if length <= 1 {
            pipeNode.addChild(makeColorizedNode(texture: singleTexture, color: color, size: size))
        } else {
            let topNode = makeColorizedNode(texture: topTexture, color: color, size: size)
            pipeNode.addChild(topNode)
            var nextPosition = CGPoint(x: 0, y: -size.height)

            for _ in 0..<(length-2) {
                let node = makeColorizedNode(texture: centerTexture, color: color, size: size)
                node.position = nextPosition
                pipeNode.addChild(node)
                nextPosition = CGPoint(x: 0, y: nextPosition.y - size.height)
            }

            let bottomNode = makeColorizedNode(texture: bottomTexture, color: color, size: size)
            bottomNode.position = nextPosition
            pipeNode.addChild(bottomNode)
        }

        let physicsRect = CGSize(width: size.width, height: size.height * CGFloat(length))
        let physicsCenter = CGPoint(x: 0, y: -size.height * CGFloat(length - 1) / 2)
        pipeNode.physicsBody = SKPhysicsBody(rectangleOf: physicsRect, center: physicsCenter)
        pipeNode.physicsBody?.isDynamic = false

        return pipeNode
    }
}
