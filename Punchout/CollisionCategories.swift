//
//  CollisionCategories.swift
//  Punchout
//
//  Created by Matt Gruber on 11/15/16.
//  Copyright © 2016 Larry Heimann. All rights reserved.
//

struct CollisionCategories{
    static let Opponent : UInt32 = 0x1 << 0
    static let Punch: UInt32 = 0x1 << 1
    static let EdgeBody: UInt32 = 0x1 << 2
}
