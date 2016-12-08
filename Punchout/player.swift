//
//  player.swift
//  Punchout
//
//  Created by Brucey on 12/1/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import UIKit
import SpriteKit

class player: SKNode {
    let block_fist : fist
    let punch_fist : fist
    var score : Int = 0
    var panchor : SKPhysicsJointSliding?
    var banchor : SKPhysicsJointSliding?
    var manchor : SKPhysicsJointFixed?
    
    var xSpeed : CGFloat = 0
    var ySpeed : CGFloat = 0
    
    /*left_pos : CGPoint, right_pos : CGPoint*/
    override init() {
        
        block_fist = fist(fisttype: "left")
        block_fist.name = "block"
        
        punch_fist = fist(fisttype: "right")
        punch_fist.name = "punch"
        
        score = 0
        
        super.init()
    }
    
    func setFistsPos(left_pos : CGPoint, right_pos : CGPoint) {
        block_fist.position = left_pos
        punch_fist.position = right_pos
        
        let midPoint = getMiddlePoint(left_pos, p2: right_pos)
        let punchVector = CGVector(dx: CGFloat(0),
                                   dy: punch_fist.size.height * 2)
        let blockVector = CGVector(dx: CGFloat(0),
                                   dy: block_fist.size.height)
        
        panchor = SKPhysicsJointSliding.jointWithBodyA(
            punch_fist.physicsBody!,
            bodyB: block_fist.physicsBody!,
            anchor: midPoint,
            axis: punchVector)
        panchor?.shouldEnableLimits = false
        
        banchor = SKPhysicsJointSliding.jointWithBodyA(
            block_fist.physicsBody!,
            bodyB: punch_fist.physicsBody!,
            anchor: midPoint,
            axis: blockVector)
        banchor?.shouldEnableLimits = false
        
//        manchor = SKPhysicsJointFixed.jointWithBodyA(
//            punch_fist.physicsBody!,
//            bodyB: block_fist.physicsBody!,
//            anchor: midPoint
//        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getMiddlePoint(p1 : CGPoint, p2: CGPoint) -> CGPoint {
        let lx = p1.x
        let rx = p2.x
        
        let ly = p1.y
        let ry = p1.y
        
        return CGPoint(x: (lx+rx)/2 , y: (ly+ry)/2)
    }
    
    
    
    func punch(scene : SKScene) {
        self.punch_fist.punch(scene)
    }
    
    
    func block(scene : SKScene) {
        self.block_fist.block(scene)

    }
    
    func setFistBodyPhysics(dx : CGFloat, dy : CGFloat) {
        punch_fist.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        block_fist.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
    
    func moveFists(scene : SKScene,
                   leftBound : CGFloat, rightBound: CGFloat,
                   upBound : CGFloat, lowBound : CGFloat, bx: CGFloat, px: CGFloat, y: CGFloat) ->
                    (CGFloat, CGFloat, CGFloat) {
        
        var newPX = px + xSpeed
        var newBX = bx + xSpeed
        
        // forces opponent to switch direction if it hits the edge
        if(newPX > rightBound
        || newBX < leftBound){
            newPX = px
            newBX = bx
        }
        
        var newY = y + ySpeed
                        
        if(newY > upBound
        || newY < lowBound){
            newY = y
        }
        
        // restore relative positions of the two fists
        // so they stay close together
        if (outOfPosition()) {
            restorePositions()
        }
        
        return (newBX, newPX, newY)
    }
    
    // Move fists back together after moveFists
    func restorePositions() {
        let halfY = (block_fist.position.y + punch_fist.position.y) / 2
        let halfX = (block_fist.position.x + punch_fist.position.x) / 2
        let newBlockX = (halfX - block_fist.size.width / 2)
        let newPunchX = (halfX + punch_fist.size.width / 2)
            
        block_fist.position.y = halfY
        block_fist.position.x = newBlockX - 10
            
        punch_fist.position.y = halfY
        punch_fist.position.x = newPunchX + 10
    }
    
    func outOfPosition() -> Bool {
        let offset = CGFloat(10)
        let combWidth = block_fist.size.width / 2 + punch_fist.size.width / 2
        let punchBound = block_fist.position.x + combWidth + offset
        let blockBound = punch_fist.position.x - combWidth - offset
        
        let yDis = abs(block_fist.position.y - punch_fist.position.y)
        
        return (block_fist.position.x >= blockBound
            ||  punch_fist.position.x <= punchBound
            ||  yDis >= offset)
//        
//        
//        
//        let distance = block_fist.position.x - punch_fist.position.x
//        let combWidth = block_fist.size.width / 2 + punch_fist.size.width / 2
//        
//        let offset = CGFloat(10)
//        
//        let offY = abs(block_fist.position.y - punch_fist.position.y)
//        
//        return ((distance <= 0)
//            || (distance >= combWidth + offset)
//            || offY > offset)
//        
    }
    
    
}
