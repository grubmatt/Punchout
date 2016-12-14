//
//  PlayerTests.swift
//  Punchout
//
//  Created by Brucey on 12/14/16.
//  Copyright © 2016 CMU. All rights reserved.
//
import XCTest
import SpriteKit
@testable import Punchout

class PlayerTests: XCTestCase {
    
    var user : Player?
    var scene : SKScene?
    
    override func setUp() {
        super.setUp()
        // The setup called before the invocation of each test method
        user = Player()
        scene = GameScene()
    }
    
    override func tearDown() {
        // The teardown called after the invocation of each test method
        super.tearDown()
        user = nil
        scene = nil
    }
    
    // see if the player is initilized correctly
    func testPlayerInit() {
        if let p = user {
            XCTAssertEqual(p.score, 0)
        } else {
            print("Did not correctly create player")
            XCTFail()
        }
    }
    
    // Testing set positon function
    // A SKPhysicsJointSliding should be created to
    // allow the fists to slide along that axis
    // The axis should be located at the middle point of the fists
    // with a vector of (0, 90), i.e. vertical
    func testSetPosition() {
        if let p = user {
            let left = CGPoint(x: 50, y: 50)
            let right = CGPoint(x: 100, y: 50)
            p.setFistsPos(left, right_pos: right)
            
            if let anchor = p.pbanchor {
                XCTAssertFalse(anchor.shouldEnableLimits)
            }
        } else {
            print("Did not correctly create plyaer")
            XCTFail()
        }
    }
}
