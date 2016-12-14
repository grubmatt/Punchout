//
//  TutorialSceneTests.swift
//  Punchout
//
//  Created by Brucey on 12/1/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Punchout

class TutorialSceneTests: XCTestCase {
    
    var scene : TutorialScene?
    
    override func setUp() {
        super.setUp()
        // The setup called before the invocation of each test method
        scene = TutorialScene()
    }
    
    override func tearDown() {
        // The teardown called after the invocation of each test method
        super.tearDown()
        scene = nil
    }
    
    // Test whether label is created successfully
    func testlabelSetup() {
        if let tutorial = scene {
            tutorial.setupLabels()
            XCTAssertEqual(tutorial.textLabel_1.text,"Block")
            XCTAssertEqual(tutorial.textLabel_2.text, "Punch")
        } else {
            print ("fail to initialize labels correctly")
            XCTFail()
        }
    }
    
    
    // Test the functionality of next
    func testNext() {
        if let tutorial = scene {
            XCTAssertEqual(tutorial.tutorialPosition, 0)
            
            tutorial.next()
            XCTAssertEqual(tutorial.tutorialPosition, 1)
            XCTAssertEqual(tutorial.textLabel_1.text, "Tilt to move")
            XCTAssertEqual(tutorial.textLabel_2.text, "")
            
            tutorial.next()
            XCTAssertEqual(tutorial.tutorialPosition, 2)
            XCTAssertEqual(tutorial.textLabel_1.text, "Punch Him!")
            
            tutorial.next()
            XCTAssertEqual(tutorial.tutorialPosition, 3)
            XCTAssertEqual(tutorial.textLabel_1.text, "Block Him!")
            
            tutorial.next()
            XCTAssertEqual(tutorial.tutorialPosition, 4)
        } else {
            print ("fail to inialize tutorial scene correctly")
            XCTFail()
        }
    }
}
