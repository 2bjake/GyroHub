//
//  GameViewController.swift
//  GyroPad
//
//  Created by Jake Foster on 6/24/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = view as! SKView?,
            let scene = SKScene(fileNamed: "EmptyGameScene") else {
                fatalError("could not load scene")
        }

        scene.scaleMode = .aspectFill
        view.ignoresSiblingOrder = true
        view.showsPhysics = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
