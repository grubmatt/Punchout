//
//  Opponent.swift
//  Punchout
//
//  Created by Brucey on 11/17/16.
//  Copyright © 2016 Larry Heimann. All rights reserved.
//

import Foundation
import SpriteKit

class Opponent : SKSpriteNode {
    
    var points = 0
    var xSpeed: CGFloat = 3
    var ySpeed: CGFloat = 3
    var lastPunch: CGFloat = 0
    
    init() {
        let texture = SKTexture(imageNamed: "opponent_1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "opponent"
        self.setScale(1.5)
        
        // preparing opponent for collisions once we add physics...
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // SKSpriteNode conforms to NSCoding, which requires we implement this, but we can just call super.init()
        super.init(coder: aDecoder)
    }
    
    func animate(){
        var opponentTextures:[SKTexture] = []
        for i in 0...1 {
            opponentTextures.append(SKTexture(imageNamed: "opponent_\(i)"))
        }
        let opponentAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(opponentTextures, timePerFrame: 0.15))
        self.runAction(opponentAnimation)
        
    }
    
    func sendPunch(scene: SKScene){
        var opponentTextures:[SKTexture] = []
        for i in 1...3 {
            opponentTextures.append(SKTexture(imageNamed: "opponent_\(i)"))
        }
        opponentTextures.append(SKTexture(imageNamed: "opponent_1"))
        let opponentAnimation = SKAction.animateWithTextures(opponentTextures, timePerFrame: 0.15)
        self.runAction(opponentAnimation)
        
    }
    
    func sendBlock(scene: SKScene){
        var opponentTextures:[SKTexture] = []
        opponentTextures.append(SKTexture(imageNamed: "opponent_1"))
        opponentTextures.append(SKTexture(imageNamed: "opponent_block"))
        opponentTextures.append(SKTexture(imageNamed: "opponent_1"))
        let opponentAnimation = SKAction.animateWithTextures(opponentTextures, timePerFrame: 0.15)
        self.runAction(opponentAnimation)
        
    }
    
    func shouldPunch() -> Bool {
        // Sliding chance that opponent will send a punch
        // The more time = more likely to punch
        let slide = UInt32(11 - Int(lastPunch)/6)
        if(lastPunch > 15) {
            if (Int(arc4random_uniform(slide)) == 1) {
                return true
            }
        }
        
        return false
    }
    
    func shouldBlock() -> Bool {
        // 1 in 10 chance that opponent will send a punch
        if (Int(arc4random_uniform(11)) == 1) {
            return true
        } else {
            return false
        }
    }
    
    func move(scene: SKScene, upperBounds: CGFloat, lowerBounds: CGFloat, leftBounds: CGFloat, rightBounds: CGFloat, x: CGFloat, y: CGFloat) -> (CGFloat, CGFloat){
        var changeDirection = false
        let newX = x - xSpeed
        
        // forces opponent to switch direction if it hits the edge
        if(newX >= rightBounds
            || newX <= leftBounds){
            changeDirection = true
        }
        
        // 1 in 6 chance that opponent will switch direction
        var randomChance = Int(arc4random_uniform(7))
        if( randomChance == 1) {
            changeDirection = true
        }
        
        if(changeDirection == true){
            xSpeed *= -1
        }
        
        changeDirection = false
        
        let newY = y - ySpeed
        
        if(newY >= upperBounds
            || newY <= lowerBounds){
            changeDirection = true
        }
        
        // 1 in 6 chance that opponent will switch direction
        randomChance = Int(arc4random_uniform(7))
        if( randomChance == 1) {
            changeDirection = true
        }
        
        if(changeDirection == true){
            ySpeed *= -1
        }
        
        return (newX, newY)
    }
}
