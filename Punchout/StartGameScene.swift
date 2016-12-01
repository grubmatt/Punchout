//
//  StartGameScene.swift
//  Punchout
//
//  Created by Brucey on 11/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import UIKit
import SpriteKit

class StartGameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPointMake(size.width/2,size.height/2 - 100)
        startGameButton.name = "startgame"
        addChild(startGameButton)
    }
}
