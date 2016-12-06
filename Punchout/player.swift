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
    
    let movementArray = [-1, 1]
    
    
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
        // move both pair of fists randomly to left or right
        let randomIndex = Int(arc4random_uniform(UInt32(movementArray.count)))
//        let randomHMove = movementArray[randomIndex]
        let left = block_fist.position.x - block_fist.size.width / 2
        let right = punch_fist.position.x + punch_fist.size.width / 2
        let upper = block_fist.position.y + block_fist.size.height / 2
        let lower = block_fist.position.y - block_fist.size.height / 2
        
        var randomHorizontalMove = (left <= leftBound) ? 1 :
            ((right >= rightBound) ? -1 : movementArray[randomIndex])
        var randomVerticalMove = (upper >= upBound) ? -1 :
            ((lower <= lowBound) ? 1 : movementArray[randomIndex])
        
        let moveX = CGFloat(randomHorizontalMove) * block_fist.size.width / 2
        let moveY = CGFloat(randomVerticalMove) * block_fist.size.height / 2
        
        block_fist.move(scene, dx: moveX, dy: moveY)
        punch_fist.move(scene, dx: moveX, dy: moveY)
    }
}
