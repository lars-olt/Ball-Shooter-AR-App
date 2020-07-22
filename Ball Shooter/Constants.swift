//
//  Constants.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/23/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import Foundation


struct Fonts {
    static let Main = "Roboto-Regular"
    static let Title = "Raleway-Light"
    static let Info = "Raleway-Regular"
}

struct Images {
    static let noLevel = "Locked Level"
    static let Level0 = "Unlocked_Level_0"
    static let Level1 = "Unlocked_Level_1"
    static let Level2 = "Unlocked_Level_2"
    static let Level3 = "Unlocked_Level_3"
    
    static let nextLevelBtnOn = "Next_Level_Btn_on"
    static let nextLevelBtnOff = "Next_Level_Btn_off"
    
    static let finishBtn = "Finish_Btn"
    static let nextBtn = "Next_Btn"
}

struct Message {
    static let win = "Level Complete!"
    static let loose = "So Close"
}

struct FinalStars {
    static let star_0 = "Star_Count_0"
    static let star_1 = "Star_Count_1"
    static let star_2 = "Star_Count_2"
    static let star_3 = "Star_Count_3"
}

struct TargetScore {
    static let noStars = 1_200
}

struct Keys {
    static let played = "playedBefore"
    static let levelsStarCount = "savedLevelsStarCount"
    static let unlockedLevels = "savedUnlockedLevels"
}

struct ResumeGame {
    static let resumeMsg = "Tap on the screen to resume your game."
    static let restartMsg = "Tap on the screen to restart your game."
}
