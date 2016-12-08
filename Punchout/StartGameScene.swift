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
    
    let dm = DataManager()
    
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
        shortGameButton.text = "Fight"
        addChild(shortGameButton)
        
        let highScoreButton = SKLabelNode()
        highScoreButton.position = CGPointMake(size.width/2,size.height/5.5)
        highScoreButton.name = "highscore"
        highScoreButton.text = "High Score"
        addChild(highScoreButton)
        
        let tutorialButton = SKLabelNode()
        tutorialButton.position = CGPointMake(size.width/2,size.height/9)
        tutorialButton.name = "tutorial"
        tutorialButton.text = "Tutorial"
        addChild(tutorialButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "shortgame" {
            dm.loadScore()
            let shortScene = GameScene(size: size)
            shortScene.gameLength = 31
            shortScene.highScore = dm.score
            shortScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(0.75)
            view?.presentScene(shortScene,transition: transitionType)
        }
        
        if touchedNode.name == "highscore" {
            dm.loadScore()
            let highScoreScene = HighScoreScene(size: size)
            highScoreScene.highScore = dm.score
            highScoreScene.scaleMode = scaleMode
            let transitionType = SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 0.75)
            view?.presentScene(highScoreScene,transition: transitionType)
        }
        
        if touchedNode.name == "tutorial" {
            let tutorialScene = TutorialScene(size: size)
            tutorialScene.scaleMode = scaleMode
            let transitionType = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.75)
            view?.presentScene(tutorialScene,transition: transitionType)
        }
    }
    
}
