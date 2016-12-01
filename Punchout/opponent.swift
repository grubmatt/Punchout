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
        punch.position.x = self.position.x
        punch.position.y = self.position.y - self.size.height/2
        scene.addChild(punch)
        let movePunchAction = SKAction.moveTo(CGPoint(x:self.position.x,y: 0 - punch.size.height), duration: 2.0)
        let removePunchAction = SKAction.removeFromParent()
        punch.runAction(SKAction.sequence([movePunchAction,removePunchAction]))
    }
    
    func sendBlock(scene: SKScene){
        
    }
}
