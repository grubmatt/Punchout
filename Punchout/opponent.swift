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
    
    init() {
        let texture = SKTexture(imageNamed: "opponent_1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "opponent"
        self.setScale(1.5)
        
        // preparing opponent for collisions once we add physics...
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        // SKSpriteNode conforms to NSCoding, which requires we implement this, but we can just call super.init()
        super.init(coder: aDecoder)
    }
    
//    func animate(){
//        var opponentTextures:[SKTexture] = []
//        for i in 0...1 {
//            opponentTextures.append(SKTexture(imageNamed: "opponent_\(i)"))
//        }
//        let opponentAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(opponentTextures, timePerFrame: 0.15))
//        self.runAction(opponentAnimation)
//        
//    }

    
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
    
    func blocked(){
    
    }
}
