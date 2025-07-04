//
//  GameViewController.swift
//  ATC Simulator macOS
//
//  Created by Eshaan Rana on 7/4/25.
//

import Cocoa
import SpriteKit

class GameViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let skView = self.view as? SKView {
            let scene = MenuScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
}
