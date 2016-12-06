//
//  GameScene.swift
//  SDStarter
//
//  Created by Larry Heimann on 11/14/16.
//  Copyright (c) 2016 Larry Heimann. All rights reserved.
//

import SpriteKit


//let block_fist : Fist = Fist(Fisttype: "block")
//let punch_fist : Fist = Fist(Fisttype: "punch")

class GameScene: SKScene {
    
    //let player:Player = Player()
    let opponent:Opponent = Opponent()
    let leftBounds = CGFloat(0)
    let rightBounds = CGFloat(UIScreen.mainScreen().bounds.width)
    
    var opponentUpperBound:CGFloat = 0.0
    var opponentLowerBound:CGFloat = 0.0
    var opponentxSpeed = CGFloat(3)
    var opponentySpeed = CGFloat(3)
    var background = SKSpriteNode(imageNamed: "boxing_ring_412x512")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor.blackColor()
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
        
        setupOpponent()
        //setupPlayer()
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
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
        sendOpponentPunch()
        //sendOpponentBlock()


    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        moveOpponent()
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
        
        var move:(CGFloat, CGFloat) = opponent.move(self, upperBounds: self.rightBounds - opponent.size.width, lowerBounds: self.leftBounds + opponent.size.width, speed: opponentxSpeed, position: opponent.position.x)
        
        opponent.position.x = move.0
        opponentxSpeed = move.1
        
        move = opponent.move(self, upperBounds: self.opponentUpperBound, lowerBounds: opponentLowerBound, speed: opponentySpeed, position: opponent.position.y)
        
        opponent.position.y = move.0
        opponentySpeed = move.1
        
       
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
    //    func setupPlayer(){
    //        block_fist.position = CGPoint(x: size.width/2 - 70,
    //                                      y: CGFloat(self.size.height / 2) - 140)
    //        punch_fist.position = CGPoint(x: size.width/2 + 70,
    //                                      y: CGFloat(self.size.height / 2) - 140)
    //
    //        addChild(block_fist)
    //        addChild(punch_fist)
    //    }

}
