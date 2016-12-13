//
//  GameOverScene.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit

// MARK: - Game Over Screen
class GameOverScene: SKScene {
    
    var userWin: Bool = true
    var userScore: Int32 = 0
    var highScore: Score = Score()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        
        var introText: String = ""
        var color: UIColor = UIColor.clearColor()
        var position: CGPoint
        var imageName: String = ""
        
        if (userWin) {
            introText = "You won with\n"
            color = UIColor.greenColor()
            position = CGPointMake(size.width/2,size.height-size.height/8)
            imageName = "mike_down"
            
            let points = SKLabelNode()
            points.position = CGPointMake(size.width/2,size.height-size.height/4)
            points.text = String(userScore) + " points!"
            points.fontColor = color
            points.fontSize = 45
            addChild(points)
            
        } else {
            introText = "You lost..."
            color = UIColor.redColor()
            position = CGPointMake(size.width/2,size.height-size.height/5)
            imageName = "mike_victory"
        }
        
        let introToMessage = SKLabelNode()
        introToMessage.position = position
        introToMessage.text = introText
        introToMessage.fontColor = color
        introToMessage.fontSize = 45
        addChild(introToMessage)
        
        let arena = SKSpriteNode(imageNamed: "boxing_ring_412x512")
        arena.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        arena.setScale(0.5)
        addChild(arena)
        
        let opponentResponse = SKSpriteNode(imageNamed: imageName)
        opponentResponse.position = CGPointMake(size.width/2, size.height/2 + opponentResponse.size.height/3)
        opponentResponse.setScale(0.9)
        addChild(opponentResponse)
        
        let spotLight = SKSpriteNode(imageNamed: "spot_light")
        spotLight.position = CGPointMake(size.width/2, size.height/2+spotLight.size.height/10)
        spotLight.setScale(0.4)
        spotLight.alpha = 0.5
        addChild(spotLight)
        
        if(userWin && userScore > highScore.userScore) {
            let highScoreLabel = SKLabelNode()
            highScoreLabel.position = CGPointMake(size.width/2,size.height/4.5)
            highScoreLabel.text = "New High Score!"
            highScoreLabel.fontSize = 30
            highScoreLabel.fontColor = color
            addChild(highScoreLabel)
            
            let highScoreButton = SKLabelNode()
            highScoreButton.position = CGPointMake(size.width/2,size.height/7)
            highScoreButton.name = "addScore"
            highScoreButton.text = "Add Score"
            addChild(highScoreButton)
        } else {
            let backToMenuButton = SKLabelNode()
            backToMenuButton.position = CGPointMake(size.width/2,size.height/7)
            backToMenuButton.name = "menu"
            backToMenuButton.text = "Main Menu"
            addChild(backToMenuButton)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "menu" {
            let menuScene = StartGameScene(size: size)
            menuScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(0.75)
            view?.presentScene(menuScene,transition: transitionType)
        }
        if touchedNode.name == "addScore" {
            let scoreScene = AddScoreScene(size: size)
            scoreScene.userScore = userScore
            scoreScene.scaleMode = scaleMode
            view?.presentScene(scoreScene)
        }
        
    }
}

