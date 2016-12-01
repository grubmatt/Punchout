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
        
        let shortGameButton = SKSpriteNode(imageNamed: "30seconds-start")
        shortGameButton.position = CGPointMake(size.width/2,size.height/2 - 100)
        shortGameButton.name = "shortgame"
        addChild(shortGameButton)
        
        let longGameButton = SKSpriteNode(imageNamed: "60seconds-start")
        longGameButton.position = CGPointMake(size.width/2,size.height/2 - 200)
        longGameButton.name = "longgame"
        addChild(longGameButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "shortgame" {
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        
        if touchedNode.name == "longgame" {
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
    }
    
}
