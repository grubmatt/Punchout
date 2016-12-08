//
//  DataManager.swift
//  Punchout
//
//  Created by Matt Gruber on 12/8/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - String Extension
extension String {
    // recreating a function that String class no longer supports in Swift 2.3
    // but still exists in the NSString class. (This trick is useful in other
    // contexts as well when moving between NS classes and Swift counterparts.)
    
    /**
     Returns a new string made by appending to the receiver a given string.  In this case, a new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator.
     
     - parameter aPath: The path component to append to the receiver. (String)
     
     - returns: A new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator. (String)
     
     */
    func stringByAppendingPathComponent(aPath: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(aPath)
    }
}


// MARK: - Data Manager Class
class DataManager {
    
    // MARK: - General
    var score = Score()
    
    init() {
        loadScore()
        print("Documents folder is \(documentsDirectory())\n")
        print("Data file path is \(dataFilePath())")
    }
    
    
    // MARK: - Data Location Methods
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("Score.plist")
    }
    
    
    // MARK: - Saving & Loading Data
    
    /**
     Saves score data to a plist.
     */
    
    func saveScore() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(score, forKey: "Score")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    /**
     Loads the scores from a plist into contacts array.
     */
    
    func loadScore() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                self.score = unarchiver.decodeObjectForKey("Score") as! Score
                unarchiver.finishDecoding()
            } else {
                print("\nFILE NOT FOUND AT: \(path)")
            }
        }
    }
}

