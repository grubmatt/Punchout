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
    
    init() {
        let texture = SKTexture(imageNamed: "opponent-\(1)")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "opponent"
        
        // preparing opponent for collisions once we add physics...
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        // SKSpriteNode conforms to NSCoding, which requires we implement this, but we can just call super.init()
        super.init(coder: aDecoder)
    }
    
    func sendPunch(scene: SKScene){
        let punch = OpponentPunch(imageName: "circle")
        punch.position.x = self.position.x-10
        punch.position.y = self.position.y - self.size.height/2
        scene.addChild(punch)
        let movePunchAction = SKAction.moveTo(CGPoint(x:self.position.x,y: self.position.y/2), duration: 0.5)
        let returnPunchAction = SKAction.moveTo(CGPoint(x:self.position.x,y: self.position.y-10), duration: 0.5)
        let removePunchAction = SKAction.removeFromParent()
        punch.runAction(SKAction.sequence([movePunchAction,returnPunchAction, removePunchAction]))
    }
    
    func sendBlock(scene: SKScene){
        let block = OpponentBlock(imageName: "Spaceship")
        block.position.x = self.position.x+10
        block.position.y = self.position.y - self.size.height/2
        scene.addChild(block)
        let moveBlockAction = SKAction.moveTo(CGPoint(x:self.position.x,y: self.position.y/2), duration: 0.5)
        let returnBlockAction = SKAction.moveTo(CGPoint(x:self.position.x,y: self.position.y-10), duration: 0.5)
        let removeBlockAction = SKAction.removeFromParent()
        block.runAction(SKAction.sequence([moveBlockAction,returnBlockAction, removeBlockAction]))
    }
}
