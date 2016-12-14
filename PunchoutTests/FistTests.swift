//
//  fistTests.swift
//  Punchout
//
//  Created by Brucey on 12/10/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Punchout

class FistTests: XCTestCase {
    
    var left : Fist?
    var right: Fist?
    var scene: SKScene?
    
    override func setUp() {
        super.setUp()
        // The setup called before the invocation of each test method
        left = Fist(fisttype: "left")
        right = Fist(fisttype: "right")
        scene = GameScene()
    }
    
    override func tearDown() {
        // The teardown called after the invocation of each test method
        super.tearDown()
        left = nil
        right = nil
        scene = nil
    }
    
    // Test whether the block fist is created correctly
    func testLeftInit() {
        if let block = left {
            XCTAssert(block.canMove)
            XCTAssert(block.physicsBody!.dynamic)
            XCTAssert(block.physicsBody!.usesPreciseCollisionDetection)
            XCTAssertEqual(block.physicsBody!.contactTestBitMask, 0x0)
            XCTAssertFalse(block.physicsBody!.affectedByGravity)
            XCTAssertFalse(block.physicsBody!.allowsRotation)
        } else {
            print("Left fist not initialized correctly")
            XCTFail()
        }
    }
    
    // Test whether the block fist is created correctly
    func testRightInit() {
        if let punch = right {
            XCTAssert(punch.canMove)
            XCTAssert(punch.physicsBody!.dynamic)
            XCTAssert(punch.physicsBody!.usesPreciseCollisionDetection)
            XCTAssertEqual(punch.physicsBody!.categoryBitMask,
                           CollisionCategories.Punch)
            XCTAssertEqual(punch.physicsBody!.contactTestBitMask,
                           CollisionCategories.Opponent)
            XCTAssertEqual(punch.physicsBody!.collisionBitMask, 0x0)
            XCTAssertFalse(punch.physicsBody!.affectedByGravity)
            XCTAssertFalse(punch.physicsBody!.allowsRotation)
        } else {
            print("Right fist not initialized correctly")
            XCTFail()
        }
    }
    
    // Test the behavior of blocking
    // Notice only timing can be roughly tested
    // The block motion is in a sequence of complete action
    // It is not possible to see whether the fist travelled a certain distance
    func testBlock() {
        if let block = left {
            let timeStart = NSDate()
            block.block(scene!)
            let timeEnd = NSDate()
            XCTAssert(almostEqual(timeStart, time2: timeEnd,
                value: 0.0002, offset: 0.0001))
        } else {
            print("Incorrect timing on block")
            XCTFail()
        }
    }
    
    // Test the behavior of punching
    // Notice only timing can be roughly tested
    // The punch motion is in a sequence of complete action
    // It is not possible to see whether the fist travelled a certain distance
    func testPunch() {
        if let punch = right {
            let timeStart = NSDate()
            punch.punch(scene!)
            let timeEnd = NSDate()
            XCTAssert(almostEqual(timeStart, time2: timeEnd,
                value: 0.0002, offset: 0.0001))
        } else {
            print("Incorrect timing on punch")
            XCTFail()
        }
    }
    
    
    // Helper function that allows an offset in the time comparision
    private func almostEqual(time1 : NSDate,
                             time2 : NSDate,
                             value : NSTimeInterval,
                             offset : NSTimeInterval) -> Bool {
        let upper = value + offset
        let diff = time2.timeIntervalSinceDate(time1)
        return (diff <= upper)
    }
}
