 //
//  OpponentPunch.swift
//  Punchout
//
//  Created by Matt Gruber on 11/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit

class OpponentBlock: SKSpriteNode {
    init(imageName: String){
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSize(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

