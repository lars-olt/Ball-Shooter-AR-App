//
//  LevelModel.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/24/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import Foundation

class LevelModel{
    
    func getLevels() -> [Level] {
        
        var generatedLevelArray = [Level]()
        
        for i in 1...15 {
            
            let level = Level()
            level.levelNumber = i
            level.isUnlocked = false
            
            generatedLevelArray.append(level)
            
        }
        
        return generatedLevelArray
        
    }
}
