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
        
        let nameLabel = SKLabelNode()
        nameLabel.position = CGPointMake(size.width/2,3/5*size.height)
        nameLabel.text = highScore.name
        nameLabel.fontSize = 60
        addChild(nameLabel)
        
        let userScoreLabel = SKLabelNode()
        userScoreLabel.position = CGPointMake(size.width/2,size.height/2)
        userScoreLabel.text = String(highScore.userScore) + " Points"
        userScoreLabel.fontSize = 50
        addChild(userScoreLabel)
        
        let backToMenuButton = SKLabelNode()
        backToMenuButton.position = CGPointMake(size.width/2,size.height/7)
        backToMenuButton.name = "menu"
        backToMenuButton.text = "Main Menu"
        addChild(backToMenuButton)
        
        let spotLight = SKSpriteNode(imageNamed: "spot_light")
        spotLight.position = CGPointMake(size.width/2, 3/5*size.height)
        spotLight.setScale(1)
        spotLight.alpha = 0.5
        addChild(spotLight)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "menu" {
            let menuScene = StartGameScene(size: size)
            menuScene.scaleMode = scaleMode
            let transitionType = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 0.75)
            view?.presentScene(menuScene,transition: transitionType)
        }
    }
}
