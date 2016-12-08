//
//  TutorialScene.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit
import CoreMotion


class TutorialScene: SKScene, SKPhysicsContactDelegate{
    
    
    let motionManager: CMMotionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    var accelerationY: CGFloat = 0.0
    
    var tutorialPosition = 0
    
    // Used vague names due to changing nature
    let textLabel_1 = SKLabelNode()
    let textLabel_2 = SKLabelNode()
    
    let user: player = player()
    let opponent: Opponent = Opponent()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        
        setupLabels()
        setupPlayer()
        setupOpponent()
        setupPhysics()
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
            if (tutorialPosition == 3) {
                user.block(self)
                // Timing based blocking
                if (opponent.framesSincePunch < 40) {
                    opponent.blocked()
                    textLabel_2.text = "Success!"
                } else {
                    textLabel_2.text = "You got punched!"
                }
            } else {
                user.block(self)
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        runAnimations()
        if (tutorialPosition == 1) {
            // only move if it is tilting tutorial
            movePlayer()
        }
    }
    
    func checkBlock() -> Bool {
        // Should the opponent block
        if(opponent.shouldBlock()){
            let sendBlock = SKAction.runBlock(){
                self.opponent.sendBlock(self)
            }
            runAction(sendBlock)
            return true
        }
        
        return false
    }
    
    func sendOpponentPunch(){
        // Should the opponent punch
        if(opponent.shouldPunch()){
            let sendPunch = SKAction.runBlock(){
                self.opponent.sendPunch(self)
            }
            let waitToSendPunch = SKAction.waitForDuration(1.5)
            let opponentPunch = SKAction.sequence([sendPunch,waitToSendPunch])
            runAction(opponentPunch)
            opponent.framesSincePunch = 0
        }
        opponent.framesSincePunch += 1
    }
    
    func sendOpponentBlock() {
        // Should the opponent block
        if (Int(arc4random_uniform(100)) == 1) {
            let sendBlock = SKAction.runBlock(){
                self.opponent.sendBlock(self)
            }
            let waitToSendBlock = SKAction.waitForDuration(3)
            let opponentBlock = SKAction.sequence([sendBlock, waitToSendBlock])
            runAction(opponentBlock)
        }
    }
    
    func next() {
        /* Transitions through each part of the game giving brief overview*/
        
        if (tutorialPosition == 1) {
            setupAccelerometer()
            textLabel_1.text = "Tilt to move"
            textLabel_2.text = ""
            
            textLabel_1.position = CGPointMake(size.width/2, 3/4*size.height)
        } else if (tutorialPosition == 2) {
            addChild(opponent)
            user.block_fist.removeFromParent()
            user.punch_fist.removeFromParent()
            let newLeft = opponent.position.x - user.block_fist.size.width / 2 - CGFloat(10)
            let newRight = opponent.position.x + user.punch_fist.size.width / 2 + CGFloat(10)
            let newY = opponent.position.y - user.punch_fist.size.height * 2
            
            let newLeftPos = CGPoint(x: newLeft, y: newY)
            let newRightPos = CGPoint(x: newRight, y: newY)
            user.setFistsPos(newLeftPos, right_pos: newRightPos)
            addChild(user.block_fist)
            addChild(user.punch_fist)
            
            motionManager.stopAccelerometerUpdates() // Halt accelerometer
            
            // Move Text Label to below the fists
            textLabel_2.position = CGPointMake(
                (user.block_fist.position.x + user.punch_fist.position.x) / 2,
                user.block_fist.position.y - user.block_fist.size.height)
            
            textLabel_1.text = "Punch Him!"
            textLabel_2.text = ""
        } else if (tutorialPosition == 3) {
            textLabel_1.text = "Block Him!"
            textLabel_2.text = ""
        } else if (tutorialPosition == 4) {
            let menuScene = StartGameScene(size: size)
            menuScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(menuScene,transition: transitionType)
        }
    }
    
    func runAnimations() {
        if (tutorialPosition == 2) {
            sendOpponentBlock()
        } else if (tutorialPosition == 3) {
            sendOpponentPunch()
        }
    }
    
    func movePlayer() {
        let fistSize = user.punch_fist.size
        
        let move = user.moveFists(self, leftBound: fistSize.width, rightBound: screenWidth-fistSize.width, upBound: screenHeight-fistSize.height, lowBound: fistSize.height, bx: user.block_fist.position.x, px: user.punch_fist.position.x, y: user.block_fist.position.y)
        
        user.block_fist.position.x = move.0
        user.punch_fist.position.x = move.1
        user.block_fist.position.y = move.2
        user.punch_fist.position.y = move.2
    }

    func setupLabels() {
        textLabel_1.position = CGPointMake(size.width/3, screenHeight/2 - user.block_fist.size.height)
        name = "textLabel_1"
        textLabel_1.text = "Block"
        
        textLabel_2.position = CGPointMake(2/3*size.width, screenHeight/2 - user.punch_fist.size.height)
        textLabel_2.text = "Punch"
        
        let nextButton = SKLabelNode()
        nextButton.position = CGPointMake(size.width - size.width/8, size.height/10)
        nextButton.name = "next"
        nextButton.text = "Next"
        
        addChild(textLabel_1)
        addChild(textLabel_2)
        addChild(nextButton)
    }
    
    func setupPlayer() {
        let offset = CGFloat(10)
        let left = CGPoint(
            x: screenWidth/2 - user.block_fist.size.width/2 - offset,
            y: screenHeight/2)
        
        let right = CGPoint(
            x: screenWidth/2 + user.punch_fist.size.width/2 + offset,
            y: screenHeight/2)
        
        user.setFistsPos(left, right_pos: right)
        
        addChild(user.block_fist)
        addChild(user.punch_fist)
    }
    
    func setupPhysics() {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.addJoint(user.pbanchor!)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
    }
    
    func setupOpponent(){
        opponent.position = CGPointMake(size.width/2, size.height/2)
        opponent.setScale(1.5)
        
        opponent.physicsBody?.dynamic = false
    }
    
    // MARK: - Accelerometer Methods
    func setupAccelerometer(){
        if motionManager.accelerometerAvailable == true {
            // 2
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {
                [weak self] (data: CMAccelerometerData?, error: NSError?) in
                if let acceleration = data?.acceleration {
                    self!.accelerationX = CGFloat(acceleration.x)
                    self!.accelerationY = CGFloat(acceleration.y)
                }
                })
        }
    }
    
    override func didSimulatePhysics() {
        user.xSpeed = accelerationX*30
        user.ySpeed = accelerationY*60
    }
    
    
    // MARK: - Implementing SKPhysicsContactDelegate protocol
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // When the punch overlaps with opponent
        if ((firstBody.categoryBitMask & CollisionCategories.Opponent != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Punch != 0)) {
            
            // Make sure its been at least 30 frames since last hit
            if(user.punch_fist.lastPunch > 30) {
                if (!checkBlock()) {
                    user.score += 3
                    if (tutorialPosition == 2) {
                        textLabel_2.text = "Success!"
                    }
                } else {
                    textLabel_2.text = "He blocked it!"
                }
                
                user.punch_fist.lastPunch = 0
            }
            
            user.punch_fist.lastPunch += 1
        }
        if ((firstBody.categoryBitMask & CollisionCategories.EdgeBody != 0)) {
            secondBody.velocity = CGVector(dx: 0, dy: 0)
        }
    }
}
