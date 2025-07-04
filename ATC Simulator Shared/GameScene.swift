import SpriteKit
#if os(macOS)
import AppKit
#else
import UIKit
#endif

class MenuScene: SKScene {
    private var startButtonBackground: SKShapeNode!
    private var startButtonLabel: SKLabelNode!
    private var titleBubble: SKShapeNode!
    private var titleLabel: SKLabelNode!
    private var backgroundNode: SKSpriteNode!

    override func didMove(to view: SKView) {
        layoutMenu()
    }

    private func layoutMenu() {
        removeAllChildren()
        backgroundNode?.removeFromParent()
        backgroundNode = SKSpriteNode(imageNamed: "KPDX ASDE-X")
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -2
        backgroundNode.alpha = 0.4
        if let texture = backgroundNode.texture {
            let sceneAspect = size.width / size.height
            let imageAspect = texture.size().width / texture.size().height
            if sceneAspect > imageAspect {
                backgroundNode.size = CGSize(width: size.height * imageAspect, height: size.height)
                backgroundNode.xScale = size.width / backgroundNode.size.width
                backgroundNode.yScale = 1.0
            } else {
                backgroundNode.size = CGSize(width: size.width, height: size.width / imageAspect)
                backgroundNode.xScale = 1.0
                backgroundNode.yScale = size.height / backgroundNode.size.height
            }
        }
        addChild(backgroundNode)

        let bubbleWidth: CGFloat = 800
        let bubbleHeight: CGFloat = 140
        let bubbleCorner: CGFloat = 36
        let shadow = SKShapeNode(rectOf: CGSize(width: bubbleWidth, height: bubbleHeight), cornerRadius: bubbleCorner)
        #if os(macOS)
        shadow.fillColor = SKColor(calibratedWhite: 0, alpha: 0.18)
        #else
        shadow.fillColor = SKColor(white: 0, alpha: 0.18)
        #endif
        shadow.strokeColor = .clear
        shadow.position = CGPoint(x: size.width / 2 + 4, y: size.height * 0.7 - 4)
        shadow.zPosition = 0
        shadow.alpha = 0.5
        addChild(shadow)

        titleBubble = SKShapeNode(rectOf: CGSize(width: bubbleWidth, height: bubbleHeight), cornerRadius: bubbleCorner)
        #if os(macOS)
        titleBubble.fillColor = SKColor(calibratedWhite: 1.0, alpha: 0.65)
        #else
        titleBubble.fillColor = SKColor(white: 1.0, alpha: 0.65)
        #endif
        titleBubble.strokeColor = .clear
        titleBubble.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        titleBubble.zPosition = 1
        addChild(titleBubble)

        titleLabel = SKLabelNode(text: "KPDX Ground Simulator")
        titleLabel.fontName = "Arial Rounded MT Bold"
        titleLabel.fontSize = 64
        #if os(macOS)
        titleLabel.fontColor = SKColor(calibratedRed: 0.13, green: 0.13, blue: 0.15, alpha: 1.0)
        #else
        titleLabel.fontColor = SKColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.0)
        #endif
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint.zero
        titleLabel.zPosition = 2
        titleBubble.addChild(titleLabel)

        let buttonWidth: CGFloat = 320
        let buttonHeight: CGFloat = 56
        let cornerRadius: CGFloat = 16
        let buttonShadow = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight), cornerRadius: cornerRadius)
        #if os(macOS)
        buttonShadow.fillColor = SKColor(calibratedWhite: 0, alpha: 0.18)
        #else
        buttonShadow.fillColor = SKColor(white: 0, alpha: 0.18)
        #endif
        buttonShadow.strokeColor = .clear
        buttonShadow.position = CGPoint(x: size.width / 2, y: size.height * 0.45 - 4)
        buttonShadow.zPosition = 0
        buttonShadow.alpha = 0.7
        addChild(buttonShadow)

        startButtonBackground = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight), cornerRadius: cornerRadius)
        #if os(macOS)
        startButtonBackground.fillColor = SKColor.systemBlue
        #else
        startButtonBackground.fillColor = SKColor.systemBlue
        #endif
        startButtonBackground.strokeColor = SKColor.clear
        startButtonBackground.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        startButtonBackground.name = "startButton"
        startButtonBackground.alpha = 0.98
        startButtonBackground.zPosition = 1
        addChild(startButtonBackground)

        startButtonLabel = SKLabelNode(text: "Start Simulation")
        startButtonLabel.fontName = "Arial Rounded MT Bold"
        startButtonLabel.fontSize = 28
        startButtonLabel.fontColor = .white
        startButtonLabel.verticalAlignmentMode = .center
        startButtonLabel.position = CGPoint.zero
        startButtonLabel.name = "startButton"
        startButtonBackground.addChild(startButtonLabel)
    }

    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodes = self.nodes(at: location)
        if nodes.contains(where: { $0.name == "startButton" }) {
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            titleBubble.run(fadeOut)
            startButtonBackground.run(fadeOut)
            for node in children where node is SKShapeNode && node.zPosition == 0 {
                node.run(fadeOut)
            }
            run(SKAction.wait(forDuration: 0.5)) {
                if let view = self.view {
                    let gameScene = GameScene(size: self.size)
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    view.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
    #else
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        if nodes.contains(where: { $0.name == "startButton" }) {
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            titleBubble.run(fadeOut)
            startButtonBackground.run(fadeOut)
            for node in children where node is SKShapeNode && node.zPosition == 0 {
                node.run(fadeOut)
            }
            run(SKAction.wait(forDuration: 0.5)) {
                if let view = self.view {
                    let gameScene = GameScene(size: self.size)
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    view.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
    #endif

    override func didChangeSize(_ oldSize: CGSize) {
        layoutMenu()
    }
}

class GameScene: SKScene {
    private var background: SKSpriteNode!
    private var topBar: SKShapeNode!
    private var cabLabel: SKLabelNode!
    private var asdexLabel: SKLabelNode!
    private var activeDisplay: String = "ASDE-X" // or "Cab"

    override func didMove(to view: SKView) {
        addBackground(for: activeDisplay)
        addTopBar()
        updateDisplayLabels()
    }

    private func addBackground(for display: String) {
        background?.removeFromParent()
        let imageName = (display == "Cab") ? "KPDX Tower Cab" : "KPDX ASDE-X"
        background = SKSpriteNode(imageNamed: imageName)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        if let texture = background.texture {
            let sceneAspect = size.width / size.height
            let imageAspect = texture.size().width / texture.size().height
            if sceneAspect > imageAspect {
                background.size = CGSize(width: size.height * imageAspect, height: size.height)
                background.xScale = size.width / background.size.width
                background.yScale = 1.0
            } else {
                background.size = CGSize(width: size.width, height: size.width / imageAspect)
                background.xScale = 1.0
                background.yScale = size.height / background.size.height
            }
        }
        addChild(background)
    }

    private func addTopBar() {
        // Remove if already exists
        topBar?.removeFromParent()
        cabLabel?.removeFromParent()
        asdexLabel?.removeFromParent()

        // Bar
        let barHeight: CGFloat = 32
        topBar = SKShapeNode(rectOf: CGSize(width: size.width, height: barHeight))
        topBar.fillColor = .black
        topBar.strokeColor = .clear
        topBar.position = CGPoint(x: size.width / 2, y: size.height - barHeight / 2)
        topBar.zPosition = 10
        addChild(topBar)

        // Cab label
        cabLabel = SKLabelNode(text: "Cab : PDX")
        cabLabel.fontName = "Arial Rounded MT Bold"
        cabLabel.fontSize = 18
        cabLabel.verticalAlignmentMode = .center
        cabLabel.horizontalAlignmentMode = .left
        cabLabel.position = CGPoint(x: 24 - size.width / 2, y: 0)
        cabLabel.zPosition = 11
        cabLabel.name = "cabLabel"
        topBar.addChild(cabLabel)

        // Divider
        let divider = SKShapeNode(rectOf: CGSize(width: 2, height: 20))
        divider.fillColor = SKColor(white: 0.2, alpha: 1)
        divider.strokeColor = .clear
        divider.position = CGPoint(x: 120 - size.width / 2, y: 0)
        divider.zPosition = 11
        topBar.addChild(divider)

        // ASDE-X label
        asdexLabel = SKLabelNode(text: "ASDE-X : PDX")
        asdexLabel.fontName = "Arial Rounded MT Bold"
        asdexLabel.fontSize = 18
        asdexLabel.verticalAlignmentMode = .center
        asdexLabel.horizontalAlignmentMode = .left
        asdexLabel.position = CGPoint(x: 140 - size.width / 2, y: 0)
        asdexLabel.zPosition = 11
        asdexLabel.name = "asdexLabel"
        topBar.addChild(asdexLabel)
    }

    private func updateDisplayLabels() {
        if activeDisplay == "Cab" {
            cabLabel.fontColor = SKColor(white: 0.95, alpha: 1.0)
            asdexLabel.fontColor = SKColor(white: 0.5, alpha: 1.0)
        } else {
            cabLabel.fontColor = SKColor(white: 0.5, alpha: 1.0)
            asdexLabel.fontColor = SKColor(white: 0.95, alpha: 1.0)
        }
    }

    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: topBar)
        let cabFrame = cabLabel.frame.insetBy(dx: -8, dy: -8)
        let asdexFrame = asdexLabel.frame.insetBy(dx: -8, dy: -8)
        if cabFrame.contains(location) && activeDisplay != "Cab" {
            activeDisplay = "Cab"
            addBackground(for: activeDisplay)
            updateDisplayLabels()
        } else if asdexFrame.contains(location) && activeDisplay != "ASDE-X" {
            activeDisplay = "ASDE-X"
            addBackground(for: activeDisplay)
            updateDisplayLabels()
        }
    }
    #endif

    override func didChangeSize(_ oldSize: CGSize) {
        // Re-layout on resize
        background?.removeFromParent()
        addBackground(for: activeDisplay)
        addTopBar()
        updateDisplayLabels()
    }
}
