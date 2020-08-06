//
//  Level 1.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/27/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import Foundation

// Keeps track of all of the attributes of each level in the game
var levels = [newLevel]()

struct newLevel {
    
    var ballCount: Int
    var hoopInterval: Int
    var changerInterval: Int
    var randomColorInterval: Int
    var objectSpeed: Int
    var oneStarScore: Int
    var twoStarsScore: Int
    var threeStarsScore: Int
    var objectYIncrease: Double
    
}

func createLevels() {
    var rowIncrease = 0
    let scorePerBall = 600
    let ballsAddedPerRound = 2
    var yIncrease = 0.0
    
    for levelNumber in 0...14 {
        
        // Every 3 levels, increment rowIncrease value
        if levelNumber != 0 && levelNumber % 3 == 0 { rowIncrease += 1; yIncrease += 0.5}
        
        let ballCount = 10 + (levelNumber * ballsAddedPerRound)
        let changerInterval = 9 + rowIncrease
        let changerAccountance = Int(floor(Double(currentLevelBallCount ?? 0 / changerInterval)))
        let pointIncrease = ((levelNumber * (scorePerBall * ballsAddedPerRound)) - changerAccountance) / 2
        
        levels.append( newLevel(
            ballCount: ballCount,
            hoopInterval: 4 - rowIncrease, // NOTE: - Must be different from the changerInterval
            changerInterval: changerInterval,
            randomColorInterval: 5,
            objectSpeed: 6 - rowIncrease,
            oneStarScore: 2_000 + pointIncrease,
            twoStarsScore: 6_000 + pointIncrease,
            threeStarsScore: 6_000 + pointIncrease,
            objectYIncrease: yIncrease
        ))
    }
    
}
