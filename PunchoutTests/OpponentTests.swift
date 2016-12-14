//
//  OpponentTests.swift
//  Punchout
//
//  Created by Brucey on 12/14/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Punchout

class OpponentTests: XCTestCase {
    
    var enemy : Opponent?
    var scene : SKScene?
    
    override func setUp() {
        super.setUp()
        // The setup called before the invocation of each test method
        enemy = Opponent()
        scene = GameScene()
    }
    
    override func tearDown() {
        // The teardown called after the invocation of each test method
        super.tearDown()
        enemy = nil
        scene = nil
    }
    
    //Test whether the opponent is created correctly
    func testOpponentInit() {
        if let badGuy = enemy {
            XCTAssertEqual(badGuy.name, "opponent")
            XCTAssertEqual(badGuy.score, 0)
            XCTAssertEqual(badGuy.framesSincePunch, 0)
            XCTAssert(badGuy.physicsBody!.dynamic)
            XCTAssert(badGuy.physicsBody!.usesPreciseCollisionDetection)
            XCTAssertEqual(badGuy.physicsBody!.categoryBitMask,
                           CollisionCategories.Opponent)
            XCTAssertEqual(badGuy.physicsBody!.contactTestBitMask,
                           CollisionCategories.Punch)
            XCTAssertEqual(badGuy.physicsBody!.collisionBitMask, 0x0)
            XCTAssertFalse(badGuy.physicsBody!.affectedByGravity)
        } else {
            print("Fail to initialize opponent")
            XCTFail()
        }
    }
    
    // Test the behavior of opponetn blocking
    // Notice only timing can be roughly tested
    // The block motion is in a sequence of complete action
    // It is not possible to see whether the texture is changed within this sequence
    // Note: first test might fail due to caching.
    // If run multiple times, the result is mostly success
    func testOpponentBlock() {
        if let badGuy = enemy {
            let timeStart = NSDate()
            badGuy.sendBlock(scene!)
            let timeEnd = NSDate()
            XCTAssert(almostEqual(timeStart, time2: timeEnd,
                     value: 0.0002, offset: 0.0001))
        } else {
            print("Fail to unwrap opponent. Incorrect initialization")
            XCTFail()
        }
    }
    
    
    // Test the behavior of punching
    // Notice only timing can be roughly tested
    // The punch motion is in a sequence of complete action
    // It is not possible to see whether the texture is changed within this sequence
    // Note: first test might fail due to caching.
    // If run multiple times, the result is mostly success
    func testOpponentPunch() {
        if let badGuy = enemy {
            let timeStart = NSDate()
            badGuy.sendPunch(scene!)
            let timeEnd = NSDate()
            XCTAssert(almostEqual(timeStart, time2: timeEnd,
                value: 0.0002, offset: 0.0001))
            XCTAssertEqual(badGuy.score, 3)
            XCTAssertEqual(badGuy.framesSincePunch, 0)
        } else {
            print("Fail to unwrap opponent. Incorrect initialization")
            XCTFail()
        }
    }

    // Helper function that allows an offset in the time comparision
    private func almostEqual(time1 : NSDate,
                             time2 : NSDate,
                             value : NSTimeInterval,
                             offset : NSTimeInterval) -> Bool {
//        let lower = value - offset
        let upper = value + offset
        let diff = time2.timeIntervalSinceDate(time1)
        print("time1: \(time1)")
        print("time2: \(time2)")
//        print("lowesr bound: \(lower)")
        print("upper bound: \(upper)")
        print("actual diff: \(diff)")
        
        return (diff <= upper)
    }
}
