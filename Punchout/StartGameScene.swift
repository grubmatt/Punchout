//
//  StartGameScene.swift
//  SDStarter
//
//  Created by Brucey on 11/17/16.
//  Copyright © 2016 Larry Heimann. All rights reserved.
//

import UIKit
import SpriteKit

class StartGameScene: SKScene {
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        
        let titleLabel = SKLabelNode()
        titleLabel.position = CGPointMake(size.width/2, size.height - size.height/6)
        titleLabel.text = "Punch Out"
        titleLabel.fontSize = 65
        addChild(titleLabel)
        
        let arena = SKSpriteNode(imageNamed: "boxing_ring_412x512")
        arena.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 1.8)
        arena.setScale(0.5)
        addChild(arena)
        
        let shortGameButton = SKLabelNode()
        shortGameButton.position = CGPointMake(size.width/2,size.height/4)
        shortGameButton.name = "shortgame"
        shortGameButton.text = "30 sec - Fight"
        addChild(shortGameButton)
        
        let longGameButton = SKLabelNode()
        longGameButton.position = CGPointMake(size.width/2,size.height/8)
        longGameButton.name = "longgame"
        longGameButton.text = "5 sec - Fight"
        addChild(longGameButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "shortgame" {
            let shortScene = GameScene(size: size)
            shortScene.gameLength = 31
            shortScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(shortScene,transition: transitionType)
        }
        
        if touchedNode.name == "longgame" {
            let longScene = GameScene(size: size)
            longScene.gameLength = 6
            longScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(longScene,transition: transitionType)
        }
    }
    
}
