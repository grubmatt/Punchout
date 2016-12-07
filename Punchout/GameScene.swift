//
//  GameScene.swift
//  SDStarter
//
//  Created by Larry Heimann on 11/14/16.
//  Copyright (c) 2016 Larry Heimann. All rights reserved.
//

import SpriteKit

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let user: player = player()
    let opponent: Opponent = Opponent()
    let timer: Timer = Timer()
    let userScore: SKLabelNode = SKLabelNode()
    let opponentScore: SKLabelNode = SKLabelNode()

    let leftBounds = CGFloat(0)
    let rightBounds = CGFloat(screenWidth)
    
    var opponentUpperBound: CGFloat = 0
    var opponentLowerBound: CGFloat = 0
    var userUpperBound: CGFloat = 0
    var userLowerBound: CGFloat = 0
    
    var gameLength: NSTimeInterval = 31
    
    var background = SKSpriteNode(imageNamed: "boxing_ring_412x512")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        setupBackground()
        setupTimer()
        setupPhysics()

        setupOpponent()
        setupPlayer()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        

        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if (touchedNode.name == "punch") {
            user.punch_fist.punch(self)
        } else if (touchedNode.name == "block") {
            user.block_fist.block(self)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        moveOpponent()
        movePlayer()

        sendOpponentPunch()
        updateLabels()
        
        // Transitions to home screen
        if (timer.hasFinished()) {
            let gameOverScene = StartGameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
    }
    
    // MARK: - Opponent Methods
    func setupOpponent(){
        opponent.position = CGPoint(x:frame.size.width / 2,
                                    y:frame.size.height / 1.6)
        addChild(opponent)
        
        opponentUpperBound = opponent.position.y + opponent.size.height
        opponentLowerBound = opponent.position.y
    }
    
    func moveOpponent(){
        
        let leftBounds = self.leftBounds + opponent.size.width
        let rightBounds = self.rightBounds - opponent.size.width
        let upperBounds = self.opponentUpperBound
        let lowerBounds = self.opponentLowerBound
        
        var move: (CGFloat, CGFloat)
        
        move = opponent.move(self,
        upperBounds: upperBounds,
        lowerBounds: lowerBounds,
        leftBounds: leftBounds,
        rightBounds: rightBounds,
        x: opponent.position.x,
        y: opponent.position.y)
        
        opponent.position.x = move.0
        opponent.position.y = move.1
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
            opponent.lastPunch = 0
        }
        opponent.lastPunch += 1
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
    
    
    // MARK: - Player Methods
    func setupPlayer() {
        user.block_fist.position = CGPoint(
            x: screenWidth/2 - user.block_fist.size.width/2,
            y: screenHeight/2 - user.block_fist.size.height/2)
        
        user.punch_fist.position = CGPoint(
            x: screenWidth/2 + user.punch_fist.size.width/2,
            y: screenHeight/2 - user.punch_fist.size.height/2)
        
        addChild(user.block_fist)
        addChild(user.punch_fist)
        
        userUpperBound = user.block_fist.position.y
        userLowerBound = user.block_fist.position.y - user.block_fist.size.height
    }
    
    func movePlayer() {
        let leftBounds = self.leftBounds + user.block_fist.size.width
        let rightBounds = self.rightBounds - user.punch_fist.size.width
        let upperBounds = self.userUpperBound
        let lowerBounds = self.userLowerBound
        
        let move = user.moveFists(self, leftBound: leftBounds, rightBound: rightBounds, upBound: upperBounds, lowBound: lowerBounds)
        
        user.block_fist.position.x = move.0
        user.punch_fist.position.x = move.1
        user.block_fist.position.y = move.2
        user.punch_fist.position.y = move.2
        
        if (user.outOfPosition()) {
            user.restorePositions()
        }
    }
    
    // MARK: - Game Management Methods
    func setupTimer() {
        timer.position = CGPointMake(screenWidth/2, screenHeight-screenHeight/10)
        timer.fontSize = 50
        addChild(timer)
        timer.startWithDuration(gameLength)
    }
    
    func setupBackground() {
        userScore.text = "0"
        userScore.fontSize = 30
        userScore.position = CGPointMake(screenWidth/10, screenHeight-screenHeight/10)
        
        opponentScore.text = "0"
        opponentScore.fontSize = 30
        opponentScore.position = CGPointMake(screenWidth-screenWidth/10, screenHeight-screenHeight/10)
        
        background.position = CGPoint(
            x: frame.size.width / 2,
            y: frame.size.height / 2)
        
        addChild(userScore)
        addChild(opponentScore)
        addChild(background)
    }
    
    func setupPhysics() {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
    }
    
    func updateLabels() {
        timer.update()
        userScore.text = String(user.score)
        opponentScore.text = String(opponent.score)
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
            
            // Make sure its been at least 20 frames since last hit
            if(user.punch_fist.lastPunch > 17) {
                if (!checkBlock()) {
                    user.score += 3
                } else {
                    opponent.score += 1
                }
                
                user.punch_fist.lastPunch = -1
            }
            
            user.punch_fist.lastPunch += 1
        }
    }

}
