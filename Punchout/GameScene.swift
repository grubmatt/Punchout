//
//  GameScene.swift
//  SDStarter
//
//  Created by Larry Heimann on 11/14/16.
//  Copyright (c) 2016 Larry Heimann. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    //let player:Player = Player()
    let opponent:Opponent = Opponent()
    let leftBounds = CGFloat(0)
    let rightBounds = CGFloat(UIScreen.mainScreen().bounds.width)
    
    var opponentSpeed = CGFloat(5)
    var background = SKSpriteNode(imageNamed: "boxing_ring_412x512")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let backgroundColor = SKColor.blackColor()
        
        background.position = CGPoint(
            x: frame.size.width / 2,
            y: frame.size.height / 2)
        
        addChild(background)
        setupOpponent()

        setupPlayer()
        //setupPlayer()
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
        } else {
            
        }

        //        for touch in touches {
        //            let location = touch.locationInNode(self)
        //
        //            let sprite = SKSpriteNode(imageNamed:"Spaceship")
        //
        //            sprite.xScale = 0.5
        //            sprite.yScale = 0.5
        //            sprite.position = location
        //
        //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        //
        //            sprite.runAction(SKAction.repeatActionForever(action))
        //
        //            self.addChild(sprite)
        //        }
//        sendOpponentPunch()
        //sendOpponentBlock()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        let leftBounds = size.width / 10
        let rightBounds = size.width / 10 * CGFloat(9)
        let upperBounds = size.height / 2
        let lowerBounds = CGFloat(0)
        
        user.moveFists(self,
                       leftBound: leftBounds, rightBound: rightBounds,
                       upBound: upperBounds, lowBound: lowerBounds)
        moveOpponent()
    }
    
    // MARK: - Opponent Methods
    func setupOpponent(){
        opponent.position = CGPoint(x:frame.size.width / 2,
                                    y:frame.size.height / 1.6)
        addChild(opponent)
    }
    
    func moveOpponent(){
        var changeDirection = false
        opponent.position.x -= CGFloat(self.opponentSpeed)
        
        // forces opponent to switch direction if it hits the edge
        if(opponent.position.x > self.rightBounds - opponent.size.width || opponent.position.x < self.leftBounds + opponent.size.width){
            changeDirection = true
        }
        
        // 1 in 6 chance that opponent will switch direction
        let randomChance = Int(arc4random_uniform(7))
        if( randomChance == 1) {
            changeDirection = true
        }
        
        if(changeDirection == true){
            self.opponentSpeed *= -1
        }
        

    }
    
    func sendOpponentPunch(){
        let sendPunch = SKAction.runBlock(){
            self.opponent.sendPunch(self)
        }
        let waitToSendPunch = SKAction.waitForDuration(1.5)
        let opponentPunch = SKAction.sequence([sendPunch,waitToSendPunch])
        runAction(opponentPunch)
    }
    
    func sendOpponentBlock(){
        let sendBlock = SKAction.runBlock(){
            self.opponent.sendBlock(self)
        }
        let waitToSendBlock = SKAction.waitForDuration(1.5)
        let opponentBlock = SKAction.sequence([sendBlock,waitToSendBlock])
        runAction(opponentBlock)
    }
    
    
    // MARK: - Player Methods
    
    func setupPlayer(){
        user.block_fist.position = CGPoint(
            x: size.width/2 - user.block_fist.size.width/2,
            y: size.height/2 - user.block_fist.size.height/2)
        
        user.punch_fist.position = CGPoint(
            x: size.width/2 + user.punch_fist.size.width/2,
            y: size.height/2 - user.punch_fist.size.height/2)
        
        addChild(user.block_fist)
        addChild(user.punch_fist)
    }
}
