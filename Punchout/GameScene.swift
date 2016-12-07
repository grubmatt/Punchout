//
//  GameScene.swift
//  SDStarter
//
//  Created by Larry Heimann on 11/14/16.
//  Copyright (c) 2016 Larry Heimann. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    let user : player = player()
    let opponent : Opponent = Opponent()
    
    let leftBounds = CGFloat(0)
    let rightBounds = CGFloat(UIScreen.mainScreen().bounds.width)
    
    var opponentUpperBound : CGFloat = 0
    var opponentLowerBound : CGFloat = 0
    var background = SKSpriteNode(imageNamed: "boxing_ring_412x512")
    
    var userUpperBound : CGFloat = 0
    var userLowerBound : CGFloat = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        background.position = CGPoint(
            x: frame.size.width / 2,
            y: frame.size.height / 2)
        
        addChild(background)
        setupOpponent()
        setupPlayer()
        
//        setupPlayer()
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
        //sendOpponentPunch()
        //sendOpponentBlock()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */


        
        moveOpponent()
        movePlayer()
        
        opponentLogic()
        
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
    
    func opponentLogic(){
        // Should the opponent block
        if(opponent.shouldBlock()){
            //sendOpponentBlock()
        }
        // Should the opponent punch
        if(opponent.shouldPunch()){
            sendOpponentPunch()
            opponent.lastPunch = 0
        }
        opponent.lastPunch += 1
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
            x: frame.size.width/2 - user.block_fist.size.width/2,
            y: frame.size.height/2 - user.block_fist.size.height/2)
        
        user.punch_fist.position = CGPoint(
            x: frame.size.width/2 + user.punch_fist.size.width/2,
            y: frame.size.height/2 - user.punch_fist.size.height/2)
        
        
        
//        opponent.position = CGPoint(x:frame.size.width / 2,
//                                    y:frame.size.height / 1.6)
//        addChild(opponent)
//        
//        opponentUpperBound = opponent.position.y + opponent.size.height
//        opponentLowerBound = opponent.position.y
        
        
        addChild(user.block_fist)
        addChild(user.punch_fist)
        
        userUpperBound = user.block_fist.position.y
        userLowerBound = user.block_fist.position.y - user.block_fist.size.height
    }
    
    func movePlayer(){
//        let leftBounds = size.width / 10
//        let rightBounds = size.width / 10 * CGFloat(9)
//        let upperBounds = user.block_fist.position.y + user.block_fist.size.height
//        let lowerBounds = user.block_fist.position.y
//        let leftBounds = background.position.x - background.size.width / 2
//        let rightBounds = background.position.x + background.size.width / 2
//        let upperBounds = background.anchorPoint.y
//        let lowerBounds = background.anchorPoint.y - background.size.height / 2
        
        let leftBounds = self.leftBounds + user.block_fist.size.width
        let rightBounds = self.rightBounds - user.punch_fist.size.width
        let upperBounds = self.userUpperBound
        let lowerBounds = self.userLowerBound
        
        let move = user.moveFists(self,
                       leftBound: leftBounds, rightBound: rightBounds,
                       upBound: upperBounds, lowBound: lowerBounds)
        user.block_fist.position.x = move.0
        user.punch_fist.position.x = move.1
        user.block_fist.position.y = move.2
        user.punch_fist.position.y = move.2
        
        if (user.outOfPosition()) {
            user.restorePositions()
        }
    }

}
