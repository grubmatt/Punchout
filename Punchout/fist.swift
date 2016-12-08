//
//  fist.swift
//  Punchout
//
//  Created by Brucey on 11/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import UIKit
import SpriteKit

class fist: SKSpriteNode {
    
    var canMove: Bool
    var lastPunch = 0
    
    init(fisttype : String) {
        let texture : SKTexture?
        canMove = true
        if (fisttype == "left") {
            texture = SKTexture(imageNamed: "block")
        } else {
            texture = SKTexture(imageNamed: "punch")
        }
        
        // texture size is creating a problem by overlapping the other fist
        super.init(texture: texture!,
                   color: SKColor.whiteColor(),
                   size: texture!.size())
        
        
        // preparing player for collisions once we add physics...
        
        if (fisttype != "left") {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
            self.physicsBody?.dynamic = true
            self.physicsBody?.usesPreciseCollisionDetection = true
            self.physicsBody?.categoryBitMask = CollisionCategories.Punch
            self.physicsBody?.contactTestBitMask = CollisionCategories.Opponent
            self.physicsBody?.collisionBitMask = 0x0
            self.physicsBody?.affectedByGravity = false
        } else {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
            self.physicsBody?.dynamic = true
            self.physicsBody?.usesPreciseCollisionDetection = true
            self.physicsBody?.collisionBitMask = 0x0
            self.physicsBody?.affectedByGravity = false
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // move fist left and up
    func punch(scene: SKScene) {
        let moveX = CGFloat(0.0)
        let moveY = self.size.height * 2
        actionHelper(scene, dx: moveX, dy: moveY)
    }
    
    
    // move fist up
    func block(scene: SKScene) {
        let moveX = CGFloat(0.0)
        let moveY = self.size.height
        actionHelper(scene, dx: moveX, dy: moveY)
    }
    
    func move(scene: SKScene, dx : CGFloat, dy : CGFloat){
        let moveFistAction = SKAction.moveTo(
            CGPoint(x: self.position.x + dx, y:self.position.y + dy),
            duration: 0.2)
        
        self.runAction(SKAction.sequence([moveFistAction]))
    }
    
    private func actionHelper(scene: SKScene, dx : CGFloat, dy : CGFloat){
        if (canMove) {
            // set canMove to false
            canMove = false
            
            // creates an action that moves the fist by dx and dy
            let moveFistAction = SKAction.moveTo(
                CGPoint(x: self.position.x + dx, y: self.position.y + dy),
                duration: 0.2)
            
            // remove that action
//            let removeFistAction = SKAction.removeFromParent()
            let returnFistAction = SKAction.moveTo(
                CGPoint(x: self.position.x, y: self.position.y),
                duration: 0.2)
            
            // animation
            self.runAction(SKAction.sequence([moveFistAction, returnFistAction]))
            
            // delay to prevent spamming a move
            let waitToEnableFire = SKAction.waitForDuration(0.5)
            runAction(waitToEnableFire,completion:{
                self.canMove = true
            })
        } else {
            print("Don't spam!")
        }
    }
    
    
}
