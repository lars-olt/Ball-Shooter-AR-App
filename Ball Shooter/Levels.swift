//
//  Level 1.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/27/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import Foundation

struct newLevel {
    
    var ballCount: Int
    var hoopCount: Int
    var hoopInterval: Int
    var changerInterval: Int
    var objectSpeed: Int
    var oneStarScore: Int
    var twoStarsScore: Int
    var threeStarsScore: Int
    
}


// Level 1
let level1 = newLevel(
    ballCount: 15,
    hoopCount: 20,
    hoopInterval: 5,
    changerInterval: 7,
    objectSpeed: 5,
    oneStarScore: 5_000,
    twoStarsScore: 10_000,
    threeStarsScore: 10_000
)
