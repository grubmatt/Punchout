//
//  HighScoreScene.swift
//  Punchout
//
//  Created by Matt Gruber on 12/8/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit
import CoreData

class HighScoreScene: SKScene {
    
    let entityName = "Score"
    let coreDataStack = CoreDataStack()

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        
        // retrieving data with CoreData
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        let sort = NSSortDescriptor(key:"name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
//        if let results = try? coreDataStack.context.executeFetchRequest(fetchRequest) as! [Score] {
//            text = String(results.count)
//        } else {
//            print("There was an error getting the results")
//        }
        
        
        let introToMessage = SKLabelNode()
        introToMessage.position = CGPointMake(size.width/2,9/10*size.height)
        introToMessage.text = ""
        introToMessage.fontSize = 30
        addChild(introToMessage)
        
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
