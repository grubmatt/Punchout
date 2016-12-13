//
//  Timer.swift
//  Punchout
//
//  Adapted from http://tutorials.tinyappco.com/SwiftGames/Timer by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import SpriteKit

// MARK: - Timer Class
// Keeps track of game time
class Timer: SKLabelNode {
    
    var endTime:NSDate!
    
    func update() {
        let timeLeftInt = Int(timeLeft())
        self.text = String(timeLeftInt)
    }
    
    func timeLeft() -> NSTimeInterval {
        let now = NSDate()
        let remainingSeconds = endTime.timeIntervalSinceDate(now)
        
        return max(remainingSeconds, 0)
    }
    
    func startWithDuration(duration: NSTimeInterval) {
        let timeNow = NSDate()
        endTime = timeNow.dateByAddingTimeInterval(duration)
    }
    
    func hasFinished() -> Bool {
        return timeLeft() == 0
    }
}
