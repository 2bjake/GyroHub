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

        //TODO: rather than draw these, can they be built with SKPhysicsBody(texture: size:) and
        // then positioned as done below?

        // pipe
        let pipePhysicsRect = CGSize(width: size.width * 0.7, height: size.height * CGFloat(length))
        let pipePhysicsCenter = CGPoint(x: 0, y: -size.height * CGFloat(length - 1) / 2)
        let pipePhysicsBody = SKPhysicsBody(rectangleOf: pipePhysicsRect, center: pipePhysicsCenter)

        // top cap
        let topPhysicsRect = CGSize(width: size.width * 0.9, height: size.height * 0.25)
        let topPhysicsCenter = CGPoint(x: 0, y: 18.75)
        let topPhysicsBody = SKPhysicsBody(rectangleOf: topPhysicsRect, center: topPhysicsCenter)

        // bottom cap
        let bottomPhysicsRect = CGSize(width: size.width * 0.9, height: size.height * 0.25)
        let bottomPhysicsCenter = CGPoint(x: 0, y: (-size.height * CGFloat(length - 1)) - 18.75)
        let bottomPhysicsBody = SKPhysicsBody(rectangleOf: bottomPhysicsRect, center: bottomPhysicsCenter)

        pipeNode.physicsBody = SKPhysicsBody(bodies: [pipePhysicsBody, topPhysicsBody, bottomPhysicsBody])
        pipeNode.physicsBody?.allowsRotation = false

        return pipeNode
    }
}
