//
//  player.swift
//  Punchout
//
//  Created by Brucey on 12/1/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import UIKit
import SpriteKit

class player {
    let block_fist : fist
    let punch_fist : fist
    var score : Int
    
    var xSpeed : CGFloat
    var ySpeed : CGFloat
    
    
    init() {
        block_fist = fist(fisttype: "left")
        block_fist.name = "block"
        
        punch_fist = fist(fisttype: "right")
        punch_fist.name = "punch"
        
        score = 0
        
        xSpeed = CGFloat(block_fist.size.width / 10)
        ySpeed = CGFloat(block_fist.size.height / 10)
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
    
    func moveFists(scene : SKScene,
                   leftBound : CGFloat, rightBound: CGFloat,
                   upBound : CGFloat, lowBound : CGFloat) {
        var changeDirection = false
        block_fist.position.x += xSpeed
        punch_fist.position.x += xSpeed
        
        // forces user to switch direction if it hits the edge
        if(punch_fist.position.x >= rightBound - block_fist.size.width
        || block_fist.position.x <= leftBound  + block_fist.size.width){
            changeDirection = true
        }
        
        // 1 in 6 chance that opponent will switch direction
        var randomChance = Int(arc4random_uniform(7))
        if( randomChance == 1) {
            changeDirection = true
        }
        
        if(changeDirection){
            xSpeed *= -1
        }
        
        changeDirection = false
        
        block_fist.position.y += ySpeed
        punch_fist.position.y += ySpeed
        
        if(block_fist.position.y <= upBound - block_fist.size.height
        || block_fist.position.y >= lowBound + block_fist.size.height){
            changeDirection = true
        }
        
        // 1 in 6 chance that opponent will switch direction
        randomChance = Int(arc4random_uniform(7))
        if( randomChance == 1) {
            changeDirection = true
        }
        
        if(changeDirection){
            ySpeed *= -1
        }
        
        // restore relative positions of the two fists
        // so they stay close together
        if (outOfPosition()) {
            restorePositions()
        }
        
    }
    
    // Move fists back together after moveFists
    private func restorePositions() {
        let halfY = (block_fist.position.y + punch_fist.position.y) / 2
        let halfX = (block_fist.position.x + punch_fist.position.x) / 2
        let newBlockX = (halfX - block_fist.size.width/2)
        let newPunchX = (halfX + punch_fist.size.width/2)
            
        block_fist.position.y = halfY
        block_fist.position.x = newBlockX
            
        punch_fist.position.y = halfY
        punch_fist.position.x = newPunchX
    }
    
    private func outOfPosition() -> Bool {
        let distance = abs(block_fist.position.x - punch_fist.position.x)
        let combWidth = block_fist.size.width / 2 + punch_fist.size.width / 2
        
        let offX = abs(distance - combWidth)
        let offY = abs(block_fist.position.y - punch_fist.position.y)
        
        return (offX >= 5 || offY >= 5)
        
    }
}
