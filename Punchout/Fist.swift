//
//  Fist.swift
//  Punchout
//
//  Created by Brucey on 11/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: Fist Class 
class Fist: SKSpriteNode {
    
    var canMove: Bool // Determines whether the fist is allowed to move
    var lastPunch = 0 // The frame that goes by since the last frame
    
    init(fisttype : String) {
        let texture : SKTexture?
        canMove = true
        
        // Initializes the image frame
        if (fisttype == "right") {
            texture = SKTexture(imageNamed: "punch")
        } else {
            texture = SKTexture(imageNamed: "block")
        }
        
        super.init(texture: texture!,
                   color: SKColor.whiteColor(),
                   size: texture!.size())
        
        // Adding physics (collision category to the body)
        // Gravity and rotation is disabled to prevent
        // excessive y-axis movement
        // and undesired behavior of fist rotation in accelerometer
        if (fisttype == "right") {
            self.physicsBody = SKPhysicsBody(texture: self.texture!,
                                             size: self.size)
            self.physicsBody?.dynamic = true
            self.physicsBody?.usesPreciseCollisionDetection = true
            self.physicsBody?.categoryBitMask = CollisionCategories.Punch
            self.physicsBody?.contactTestBitMask = CollisionCategories.Opponent
            self.physicsBody?.collisionBitMask = 0x0
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.allowsRotation = false
        } else {
            self.physicsBody = SKPhysicsBody(texture: self.texture!,
                                             size: self.size)
            self.physicsBody?.dynamic = true
            self.physicsBody?.usesPreciseCollisionDetection = true
            self.physicsBody?.collisionBitMask = 0x0
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.allowsRotation = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Animation Methods
    // move fist left and up
    func punch(scene: SKScene) {
        
        let moveX = (-self.size.width/2)
        let moveY = self.size.height * 2.5
        moveHelper(scene, dx: moveX, dy: moveY)
    }
    
    // move fist up
    func block(scene: SKScene) {
        
        let moveX = CGFloat(0.0)
        let moveY = self.size.height
        moveHelper(scene, dx: moveX, dy: moveY)
    }
    
    // Helper function that help with movement
    private func moveHelper(scene: SKScene, dx : CGFloat, dy : CGFloat){
        if (canMove) {
            // set canMove to false
            canMove = false
            
            // creates an action that moves the fist by dx and dy
            let moveFistAction = SKAction.moveTo(
                CGPoint(x: self.position.x + dx, y: self.position.y + dy),
                duration: 0.2)
            
            // remove that action
            let returnFistAction = SKAction.moveTo(
                CGPoint(x: self.position.x, y: self.position.y),
                duration: 0.2)
            
            // run the animation
            self.runAction(SKAction.sequence([moveFistAction, returnFistAction]))
            
            // delay to prevent spamming a move
            let waitToEnableFire = SKAction.waitForDuration(0.5)
            runAction(waitToEnableFire,completion:{
                self.canMove = true
            })
        }
    }
}
