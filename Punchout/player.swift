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
    var anchor : SKPhysicsJointPin?
    
    var xSpeed : CGFloat = 3
    var ySpeed : CGFloat = 3
    
    /*left_pos : CGPoint, right_pos : CGPoint*/
    override init() {
        
        block_fist = fist(fisttype: "left")
        block_fist.name = "block"
//        block_fist.position = left_pos
        
        punch_fist = fist(fisttype: "right")
        punch_fist.name = "punch"
//        punch_fist.position = right_pos
        
        score = 0
        
        super.init()
        
//        let midPoint = getMiddlePoint(left_pos, p2: right_pos)
        
//        anchor = SKPhysicsJointPin.jointWithBodyA(
//            block_fist.physicsBody!,
//            bodyB: punch_fist.physicsBody!,
//            anchor: midPoint)
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
        block_fist.canMove = false
        punch_fist.punch(scene)
        block_fist.canMove = true
        
        // add collision physics and update score: successful block +1
    }
    
    func block(scene : SKScene) {
        punch_fist.canMove = false
        block_fist.block(scene)
        punch_fist.canMove = true
        
        // add collision physics and update score: successful block  +2
    }
    
    func setFistBodyPhysics(dx : CGFloat, dy : CGFloat) {
        punch_fist.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        block_fist.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
    
    func moveFists(scene : SKScene,
                   leftBound : CGFloat, rightBound: CGFloat,
                   upBound : CGFloat, lowBound : CGFloat, bx: CGFloat, px: CGFloat, y: CGFloat) ->
                    (CGFloat, CGFloat, CGFloat) {
        
        var changeDirection = false
        let newPX = px - xSpeed
        let newBX = bx - xSpeed
        
        // forces opponent to switch direction if it hits the edge
        if(newPX > rightBound
        || newBX < leftBound){
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
                        
        if(newY < upBound
        || newY > lowBound){
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
        let newBlockX = (halfX - block_fist.size.width/2)
        let newPunchX = (halfX + punch_fist.size.width/2)
            
        block_fist.position.y = halfY
        block_fist.position.x = newBlockX - 10
            
        punch_fist.position.y = halfY
        punch_fist.position.x = newPunchX + 10
    }
    
    func outOfPosition() -> Bool {
        let distance = abs(block_fist.position.x - punch_fist.position.x)
        let combWidth = block_fist.size.width / 2 + punch_fist.size.width / 2
        
        let offX = abs(distance - combWidth)
        let offY = abs(block_fist.position.y - punch_fist.position.y)
        
        return (offX >= 15 || offY >= 15)
        
    }
    
    
}
