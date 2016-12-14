//
//  Player.swift
//  Punchout
//
//  Created by Brucey on 12/1/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: - Player Class
class Player: SKNode {
    let block_fist : Fist
    let punch_fist : Fist
    var score: Int32 = 0
    var pbanchor: SKPhysicsJointSliding?

    
    var xSpeed : CGFloat = 0
    var ySpeed : CGFloat = 0
    
    override init() {
        block_fist = Fist(fisttype: "left")
        block_fist.name = "block"
        
        punch_fist = Fist(fisttype: "right")
        punch_fist.name = "punch"
        
        score = 0
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Positioning Methods
    private func getMiddlePoint(p1 : CGPoint, p2: CGPoint) -> CGPoint {
        // Finds midpoint between gloves
        
        let lx = p1.x
        let rx = p2.x
        
        let ly = p1.y
        let ry = p1.y
        
        return CGPoint(x: (lx+rx)/2 , y: (ly+ry)/2)
    }
    
    func setFistsPos(left_pos : CGPoint, right_pos : CGPoint) {
        // Sets intial fist position
        
        block_fist.position = left_pos
        punch_fist.position = right_pos
        
        let midPoint = getMiddlePoint(left_pos, p2: right_pos)
        
        let pbVector = CGVector(dx: CGFloat(0), dy: CGFloat(90))
        
        pbanchor = SKPhysicsJointSliding.jointWithBodyA(
            punch_fist.physicsBody!,
            bodyB: block_fist.physicsBody!,
            anchor: midPoint,
            axis: pbVector)
        pbanchor?.shouldEnableLimits = false
    }

    // MARK: - Action method
    
    // Disables movement block fist to prevent spamming
    // Calls the punch function of punch fist
    func punch(scene : SKScene) {
        block_fist.canMove = false
        self.punch_fist.punch(scene)
        block_fist.canMove = true
    }
    
    // Disables movement punch fist to prevent spamming
    // Calls the block function of block fist
    func block(scene : SKScene) {
        punch_fist.canMove = false
        self.block_fist.block(scene)
        punch_fist.canMove = true
    }
    
    func moveFists(scene : SKScene,
                   leftBound : CGFloat, rightBound: CGFloat,
                   upBound : CGFloat, lowBound : CGFloat, bx: CGFloat, px: CGFloat, y: CGFloat) ->
        (CGFloat, CGFloat, CGFloat) {
            
            var newPX = px + xSpeed
            var newBX = bx + xSpeed
            
            // forces opponent to switch direction if it hits the edge
            while(newPX > rightBound) {
                newPX -= 2
                newBX -= 2
            }
            while(newBX < leftBound){
                newPX += 2
                newBX += 2
            }
            
            var newY = y + ySpeed
            
            while(newY > upBound) {
                newY -= 2
            }
            while(newY < lowBound){
                newY += 2
            }
            
            return (newBX, newPX, newY)
    }
}
