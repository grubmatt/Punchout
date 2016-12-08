//
//  AddScoreScene.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit

class AddScoreScene: SKScene {
    
    var userScore: Int32 = 0
    var opponentScore: Int32 = 0

    var highScoreText = UITextView()

    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        
        
        let introToMessage = SKLabelNode()
        introToMessage.position = CGPointMake(size.width/2,9/10*size.height)
        introToMessage.text = "Enter Name:"
        introToMessage.fontSize = 30
        addChild(introToMessage)
        
        highScoreText = UITextView(frame: CGRectMake(size.width/4, size.height/6, 200, 30))
        highScoreText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.view!.addSubview(highScoreText)
        
        let addScoreButton = SKLabelNode()
        addScoreButton.position = CGPointMake(size.width/2,4/6*size.height)
        addScoreButton.name = "addScore"
        addScoreButton.text = "Add Score"
        addChild(addScoreButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "addScore" {
            
            let dm = DataManager()
            let scoreObject = Score()
            
            scoreObject.name = highScoreText.text
            scoreObject.userScore = userScore
            scoreObject.opponentScore = opponentScore
            
            highScoreText.removeFromSuperview()
            
            dm.score = scoreObject

            dm.saveScore()
            let highScoreScene = HighScoreScene(size: size)
            highScoreScene.highScore = dm.score
            highScoreScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(highScoreScene,transition: transitionType)
        }
        
    }
}


