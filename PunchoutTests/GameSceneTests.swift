//
//  GameSceneTests.swift
//  Punchout
//
//  Created by Brucey on 12/10/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Punchout

class GameSceneTests: XCTestCase {
    
    var scene: GameScene?
    
    override func setUp() {
        super.setUp()
        // The setup called before the invocation of each test method
        scene = GameScene()
    }
    
    override func tearDown() {
        // The teardown called after the invocation of each test method
        super.tearDown()
        scene = nil
    }
    
    // Check that the opponent is correctly created
    func testGameOpponentSetup() {
        if let game = scene {
            game.setupOpponent()
            XCTAssertEqual(game.opponent.name, "opponent")
            XCTAssertEqual(game.opponent.score, 0)
            XCTAssertEqual(game.opponent.framesSincePunch, 0)
            XCTAssert(game.opponent.physicsBody!.dynamic)
            XCTAssert(game.opponent.physicsBody!.usesPreciseCollisionDetection)
            XCTAssertEqual(game.opponent.physicsBody!.categoryBitMask,
                           CollisionCategories.Opponent)
            XCTAssertEqual(game.opponent.physicsBody!.contactTestBitMask,
                           CollisionCategories.Punch)
            XCTAssertEqual(game.opponent.physicsBody!.collisionBitMask, 0x0)
            XCTAssertFalse(game.opponent.physicsBody!.affectedByGravity)
        } else {
            print("Fail to initialize gameScene")
            XCTFail()
        }
    }
    
    func testGamePlayerSetup() {
        if let game = scene {
            game.setupPlayer()
            
            XCTAssertEqual(game.user.score, 0)
            if let anchor = game.user.pbanchor {
                XCTAssertFalse(anchor.shouldEnableLimits)
            }
        } else {
            print("Fail to initialize gameScene")
            XCTFail()
        }
    }
    
    func testGameBackgroundSetup() {
        if let game = scene {
            game.setupBackground()
            XCTAssertEqual(game.userScore.text, "0")
            XCTAssertEqual(game.userScore.fontSize, 25)
            XCTAssertEqual(game.opponentScore.text, "0")
            XCTAssertEqual(game.opponentScore.fontSize, 25)
        } else {
            print("Fail to initialize gameScene")
            XCTFail()
        }
    }
    
    func testGamePhysicsSetup() {
        if let game = scene {
            game.setupPlayer()
            game.setupPhysics()
            XCTAssertEqual(game.physicsWorld.gravity,
                           CGVectorMake(0, 0))
            XCTAssertEqual(game.physicsBody!.categoryBitMask, CollisionCategories.EdgeBody)
        } else {
            print("Fail to initialize gameScene")
            XCTFail()
        }
    }
}
