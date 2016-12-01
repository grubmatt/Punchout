//
//  GameScene.swift
//  SDStarter
//
//  Created by Larry Heimann on 11/14/16.
//  Copyright (c) 2016 Larry Heimann. All rights reserved.
//

import SpriteKit

let leftBounds = CGFloat(30)
var rightBounds = CGFloat(0)
//let block_fist : Fist = Fist(Fisttype: "block")
//let punch_fist : Fist = Fist(Fisttype: "punch")

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor.blackColor()
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
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
