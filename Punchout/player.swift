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
    
    var xSpeed = CGFloat(3)
    var ySpeed = CGFloat(3)
    
    
    init() {
        block_fist = fist(fisttype: "left")
        block_fist.name = "block"
        
        punch_fist = fist(fisttype: "right")
        punch_fist.name = "punch"
        
        score = 0
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
        block_fist.position.x -= xSpeed
        punch_fist.position.x -= xSpeed
        
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
        
        if(changeDirection == true){
            xSpeed *= -1
        }
        
        changeDirection = false
        
        block_fist.position.y -= ySpeed
        punch_fist.position.y -= ySpeed
        
        if(punch_fist.position.y >= upBound - block_fist.size.height
        || block_fist.position.y <= lowBound + block_fist.size.height){
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
    }
}
