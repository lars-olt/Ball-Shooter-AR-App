//
//  Level 1.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/27/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import Foundation

// Keeps track of all of the levels in the game
var levels = [newLevel]()

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

func createLevels() {
    
    for i in 0...14 {
        
        var change = 0
        
        if (i % 3 == 0) {
            change += 1
        }
        
        levels.append( newLevel(
        ballCount: 30 + i,
        hoopCount: 20 + i,
        hoopInterval: 7 - change, // NOTE: - Must be different from the changerInterval
        changerInterval: 9,
        objectSpeed: 6 - change,
        oneStarScore: 5_000,
        twoStarsScore: 12_000,
        threeStarsScore: 12_000
        ))
    }
    
}
