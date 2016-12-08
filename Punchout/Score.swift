//
//  Score.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import Foundation
import CoreData

public class Score: NSObject {
    
    var name: String
    var userScore: Int32
    
    override init() {
        self.name = "Mike Tyson"
        self.userScore = 5
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("Name") as! String
        self.userScore = aDecoder.decodeIntForKey("UserScore") 
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeInt(userScore, forKey: "UserScore")
    }
}
