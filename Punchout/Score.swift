//
//  Score.swift
//  Punchout
//
//  Created by Matt Gruber on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

import Foundation
import CoreData

public class Score: NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var userScore: NSNumber
    @NSManaged public var opponentScore: NSNumber
    @NSManaged public var id: NSNumber
    
}
