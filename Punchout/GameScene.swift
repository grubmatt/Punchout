//
//  GameScene.swift
//  SDStarter
//
//  Created by Larry Heimann on 11/14/16.
//  Copyright (c) 2016 Larry Heimann. All rights reserved.
//

import SpriteKit




//let block_fist : fist = fist(fisttype: "left")
//let punch_fist : fist = fist(fisttype: "right")

class GameScene: SKScene {
    
    let user : player = player()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor.blackColor()
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
        } else {
            
        }
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
    }
    
    // MARK: - Opponent Methods
    func setupOpponent(){
        let tempOppo:Opponent = Opponent()
        let xPositionStart:CGFloat = size.width/2
        tempOppo.position = CGPoint(x:xPositionStart,
                                    y:CGFloat(self.size.height / 1.5))
        addChild(tempOppo)
    }
    
//    func invokeOpponentPunch(){
//        let sendPunch = SKAction.runBlock(){
//            self.sendOpponentPunch()
//        }
//        let waitToSendPunch = SKAction.waitForDuration(1.5)
//        let invaderFire = SKAction.sequence([fireBullet,waitToFireInvaderBullet])
//        let repeatForeverAction = SKAction.repeatActionForever(invaderFire)
//        runAction(repeatForeverAction)
//    }
//    
//    func sendOpponentPunch(){
//        if(invadersWhoCanFire.isEmpty){
//            levelNum += 1
//            levelComplete()
//        }else{
//            let randomInvader = invadersWhoCanFire.randomElement()
//            randomInvader.fireBullet(self)
//        }
//    }
    
    
    // MARK: - Player Methods
    func setupPlayer(){
        user.block_fist.position = CGPoint(x: size.width/2 - user.block_fist.size.width/2,
                                           y: size.height/2 - user.block_fist.size.height/2)
        user.punch_fist.position = CGPoint(x: size.width/2 + user.punch_fist.size.width/2,
                                           y: size.height/2 - user.punch_fist.size.height/2)
        addChild(user.block_fist)
        addChild(user.punch_fist)
    }
}
