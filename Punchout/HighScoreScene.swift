//
//  HighScoreScene.swift
//  Punchout
//
//  Created by Matt Gruber on 12/8/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit

class HighScoreScene: SKScene {
    
    var highScore: Score = Score()

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
                
        let introMessage = SKLabelNode()
        introMessage.position = CGPointMake(size.width/2,9/10*size.height)
        introMessage.text = "High Score!"
        introMessage.fontSize = 30
        addChild(introMessage)
        
        let nameLabel = SKLabelNode()
        nameLabel.position = CGPointMake(size.width/2,6/10*size.height)
        nameLabel.text = highScore.name
        nameLabel.fontSize = 30
        addChild(nameLabel)
        
        let userScoreLabel = SKLabelNode()
        userScoreLabel.position = CGPointMake(size.width/2,5/10*size.height)
        userScoreLabel.text = String(highScore.userScore)
        userScoreLabel.fontSize = 30
        addChild(userScoreLabel)
        
        let opponentScoreLabel = SKLabelNode()
        opponentScoreLabel.position = CGPointMake(size.width/2,4/10*size.height)
        opponentScoreLabel.text = String(highScore.opponentScore)
        opponentScoreLabel.fontSize = 30
        addChild(opponentScoreLabel)
        
        let backToMenuButton = SKLabelNode()
        backToMenuButton.position = CGPointMake(size.width/2,size.height/7)
        backToMenuButton.name = "menu"
        backToMenuButton.text = "Main Menu"
        addChild(backToMenuButton)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "menu" {
            let menuScene = StartGameScene(size: size)
            menuScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(menuScene,transition: transitionType)
        }
    }
}
