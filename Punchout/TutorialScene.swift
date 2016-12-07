//
//  TutorialScene.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene, SKPhysicsContactDelegate {
    
    var tutorialPosition = 0
    
    // Used vague names due to changing nature
    let textLabel_1 = SKLabelNode()
    let textLabel_2 = SKLabelNode()
    
    let user: player = player()
    let opponent: Opponent = Opponent()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        
        textLabel_1.position = CGPointMake(size.width/3, size.height/4)
        name = "textLabel_1"
        textLabel_1.text = "Block"
        addChild(textLabel_1)
        
        textLabel_2.position = CGPointMake(2/3*size.width, size.height/4)
        textLabel_2.text = "Punch"
        addChild(textLabel_2)
        
        let nextButton = SKLabelNode()
        nextButton.position = CGPointMake(size.width - size.width/8, size.height/10)
        nextButton.name = "next"
        nextButton.text = "Next"
        addChild(nextButton)
        
        setupPlayer()
        setupOpponent()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode.name == "next" {
            tutorialPosition += 1
            next()
        }
        if (touchedNode.name == "punch") {
            user.punch_fist.punch(self)
        } else if (touchedNode.name == "block") {
            user.block_fist.block(self)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        runAnimations()
    }
    
    func next() {
        if (tutorialPosition == 1) {
            textLabel_1.text = "Tilt to move"
            textLabel_2.text = ""
            
            textLabel_1.position = CGPointMake(size.width/2, 3/4*size.height)
        } else if (tutorialPosition == 2) {
            addChild(opponent)
            user.block_fist.removeFromParent()
            user.punch_fist.removeFromParent()
            
            textLabel_1.text = "Opponent Blocking"
            textLabel_2.text = ""
        } else if (tutorialPosition == 3) {
            textLabel_1.text = "Opponent Punching"
            textLabel_2.text = "Block this!"
        } else if (tutorialPosition == 4) {
            let menuScene = StartGameScene(size: size)
            menuScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(menuScene,transition: transitionType)
        }
    }
    
    func runAnimations(){
        if (tutorialPosition == 2) {
            opponent.sendBlock(self)
        } else if (tutorialPosition == 3) {
            opponent.sendPunch(self)
        }
    }
    
    func setupPlayer() {
        user.block_fist.position = CGPoint(
            x: screenWidth/2 - user.block_fist.size.width/2,
            y: screenHeight/2 - user.block_fist.size.height/2)
        
        user.punch_fist.position = CGPoint(
            x: screenWidth/2 + user.punch_fist.size.width/2,
            y: screenHeight/2 - user.punch_fist.size.height/2)
        
        addChild(user.block_fist)
        addChild(user.punch_fist)
        
        
    }
    
    func setupOpponent(){
        opponent.position = CGPointMake(size.width/2, size.height/2)
        opponent.setScale(1.5)
    }
    
    func setupPhysics() {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
    }

}
