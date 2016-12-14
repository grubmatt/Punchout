//
//  Opponent.swift
//  Punchout
//
//  Created by Brucey on 11/17/16.
//  Copyright © 2016 Larry Heimann. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: - Opponent Class
class Opponent : SKSpriteNode {
    
    var score: Int32 = 0
    var xSpeed: CGFloat = 3
    var ySpeed: CGFloat = 3
    var framesSincePunch: CGFloat = 0
    
    init() {
        let texture = SKTexture(imageNamed: "opponent_1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "opponent"
        self.setScale(1.5)
        
        // preparing opponent for collisions once we add physics...
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Opponent
        self.physicsBody?.contactTestBitMask = CollisionCategories.Punch
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.affectedByGravity = false
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Animation Methods
    func animate(){
        // Makes opponent appear to be moving by changing the texture
        
        var opponentTextures:[SKTexture] = []
        for i in 0...1 {
            opponentTextures.append(SKTexture(imageNamed: "opponent_\(i)"))
        }
        let opponentAnimation = SKAction.repeatActionForever(
            SKAction.animateWithTextures(opponentTextures, timePerFrame: 0.15))
        self.runAction(opponentAnimation)
    }
    
    func sendPunch(scene: SKScene){
        // Animates opponent punch
        var opponentTextures:[SKTexture] = []
        for i in 2...3 {
            opponentTextures.append(SKTexture(imageNamed: "opponent_\(i)"))
        }
        opponentTextures.append(SKTexture(imageNamed: "opponent_1"))
        let opponentAnimation = SKAction.animateWithTextures(opponentTextures, timePerFrame: 0.3)
        self.runAction(opponentAnimation)
        
        // Assume that opponent hit and preemptively add points
        // In game scene, we actually take these points off
        // if the user is able to block it
        score += 3
        framesSincePunch = 0
    }
    
    func sendBlock(scene: SKScene){
        // Animates opponent block
        var opponentTextures:[SKTexture] = []
        opponentTextures.append(SKTexture(imageNamed: "opponent_block"))
        opponentTextures.append(SKTexture(imageNamed: "opponent_1"))
        let opponentAnimation = SKAction.animateWithTextures(opponentTextures, timePerFrame: 0.2)
        self.runAction(opponentAnimation)
    }
    
    // MARK: - Opponent Logic
    func shouldPunch() -> Bool {
        // Sliding chance that opponent will send a punch
        // More time = more likely to punch
        let slide = UInt32(60 - Int(framesSincePunch)/6)
        if(framesSincePunch > 30) {
            if (Int(arc4random_uniform(slide)) == 1) {
                return true
            }
        }
        return false
    }
    
    func shouldBlock() -> Bool {
        // Random chance that opponent will send a block
        if (Int(arc4random_uniform(3)) == 1) {
            return true
        } else {
            return false
        }
    }
    
    func blocked() {
        // When opponent punches they automatically assume the hit and add points
        // This removes those points
        score -= 3
    }
    
    // Randomly move the opponetn around in a given bound
    // Returns a tuple of location that represents the x and y coordinates
    // of the end location of the opponent
    func move(scene: SKScene, upperBounds: CGFloat, lowerBounds: CGFloat,
              leftBounds: CGFloat, rightBounds: CGFloat,
              x: CGFloat, y: CGFloat) -> (CGFloat, CGFloat){
        var changeDirection = false
        let newX = x - xSpeed
        
        // forces opponent to switch direction if it hits the edge
        if(newX > rightBounds
            || newX < leftBounds){
            changeDirection = true
        }
        
        // Random chance that opponent will switch direction horizontally
        var randomChance = Int(arc4random_uniform(11))
        if( randomChance == 1) {
            changeDirection = true
        }
        
        if(changeDirection == true){
            xSpeed *= -1
        }
        
        changeDirection = false
        
        let newY = y - ySpeed
        
        if(newY > upperBounds
            || newY < lowerBounds){
            changeDirection = true
        }
        
        // Random chance that opponent will switch direction vertically
        randomChance = Int(arc4random_uniform(11))
        if( randomChance == 1) {
            changeDirection = true
        }
        
        if(changeDirection == true){
            ySpeed *= -1
        }
        
        return (newX, newY)
    }
}
