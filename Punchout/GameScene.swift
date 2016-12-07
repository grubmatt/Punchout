//
//  GameScene.swift
//  SDStarter
//
//  Created by Larry Heimann on 11/14/16.
//  Copyright (c) 2016 Larry Heimann. All rights reserved.
//

import SpriteKit
import CoreMotion

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let user: player = player()
    let opponent: Opponent = Opponent()
    let timer: Timer = Timer()

    let userScore: SKLabelNode = SKLabelNode()
    let opponentScore: SKLabelNode = SKLabelNode()
    let background = SKSpriteNode(imageNamed: "boxing_ring_412x512")
    
    let leftBounds = CGFloat(0)
    let rightBounds = CGFloat(screenWidth)
    
    var opponentUpperBound: CGFloat = 0
    var opponentLowerBound: CGFloat = 0
    var userUpperBound: CGFloat = 0
    var userLowerBound: CGFloat = 0
    
    let motionManager: CMMotionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    var accelerationY: CGFloat = 0.0
    var LdstX : CGFloat = 0.0
    var RdstX : CGFloat = 0.0
    var dstY : CGFloat = 0.0
    
    var gameLength: NSTimeInterval = 31
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        setupBackground()
        setupOpponent()
        setupPlayer()
        setupTimer()
        setupAccelerometer()
        setupPhysics()
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
        sendOpponentPunch()
        updateLabels()
        
        // Transitions to home screen
        if (timer.hasFinished()) {
            transitionToGameOver()
        }
    }
    
    // MARK: - Opponent Methods
    func setupOpponent(){
        opponent.position = CGPoint(x:screenWidth / 2,
                                    y:screenHeight / 1.6)
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
        
        
        userUpperBound = screenHeight / 1.6
        userLowerBound = screenHeight / 1.6 + 3 * user.block_fist.size.height
    }
    
    func movePlayer() {
        let leftBounds = self.leftBounds + user.block_fist.size.width
        let rightBounds = self.rightBounds - user.punch_fist.size.width
        let upperBounds = userUpperBound
        let lowerBounds = userLowerBound
    
        let move = user.moveFists(self, leftBound: leftBounds, rightBound: rightBounds, upBound: upperBounds, lowBound: lowerBounds, bx: user.block_fist.position.x, px: user.punch_fist.position.x, y: user.block_fist.position.y)
                
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
    
    func transitionToGameOver() {
        var userWin = true
        if (user.score <= opponent.score) {
            userWin = false
        }
        
        let gameOverScene = GameOverScene(size: size)
        gameOverScene.scaleMode = scaleMode
        gameOverScene.userWin = userWin
        gameOverScene.userScore = user.score
        gameOverScene.opponentScore = opponent.score
        let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
        view?.presentScene(gameOverScene,transition: transitionType)
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
    
    private func manualMovePlayer() {
        
        let userUpBounds = opponent.position.y - opponent.size.height / 2
        let userLowBounds = userLowerBound
        
        if (LdstX < leftBounds) {
            LdstX = leftBounds
        }
        
        if (RdstX > rightBounds) {
            RdstX = rightBounds
        }
        
        if (dstY > userUpBounds) {
            dstY = userUpBounds
        }
        
        if (dstY < userLowBounds) {
            dstY = userLowBounds
        }
        
        let moveLeftX = SKAction.moveToX(LdstX, duration: 0.5)
        let moveRightX = SKAction.moveToY(RdstX, duration: 0.5)
        let moveY = SKAction.moveToY(dstY, duration: 0.5)
        user.block_fist.runAction(moveLeftX)
        user.block_fist.runAction(moveY)
        user.punch_fist.runAction(moveRightX)
        user.punch_fist.runAction(moveY)
    }
    
    override func didSimulatePhysics() {
//        user.punch_fist.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: accelerationY * 600)
//        user.block_fist.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: accelerationY * 600)
        
//        user.setFistBodyPhysics(accelerationX * 600, dy : accelerationY * 600)
        
//        let userUpBounds = opponent.position.y - opponent.size.height / 2
//        let userLowBounds = userLowerBound
        
        
        
//        user.restorePositions()
        
    }
}
