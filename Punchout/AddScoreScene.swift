//
//  AddScoreScene.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit
import CoreData

class AddScoreScene: SKScene {
    
    var userScore: Int = 0
    var opponentScore: Int = 0

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
        if touchedNode.name == "addScore" {
            let entityName = "Score"
            let coreDataStack = CoreDataStack()
            let scoreEntity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: coreDataStack.context)
            
            let newScore = Score(entity: scoreEntity!, insertIntoManagedObjectContext: coreDataStack.context)
            
            newScore.id = 1
            newScore.name = highScoreText.text
            newScore.userScore = userScore
            newScore.opponentScore = opponentScore
            
            
            coreDataStack.saveContext()
            
            let highScoreScene = HighScoreScene(size: size)
            highScoreScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(highScoreScene,transition: transitionType)
        }
        
    }
}


