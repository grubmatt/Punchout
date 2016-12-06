//
//  CollisionCategories.swift
//  Punchout
//
//  Created by Matt Gruber on 11/15/16.
//  Copyright © 2016 Larry Heimann. All rights reserved.
//

struct CollisionCategories{
    static let Opponent : UInt32 = 0x1 << 0
    static let PlayerPunch: UInt32 = 0x1 << 1
    static let PlayerBlock: UInt32 = 0x1 << 2
    static let OpponentPunch: UInt32 = 0x1 << 3
    static let OpponentBlock: UInt32 = 0x1 << 4
    static let EdgeBody: UInt32 = 0x1 << 5
}
