//
//  LevelCollectionViewCell.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/24/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var levelNumber: UILabel!
    
    var level: Level?
    
    // Sets up the initial state of the levels
    func setLevel(_ level: Level) {
        
        self.level = level
        
        if level.isUnlocked {
            
            let starsCount = String(level.stars)
            let image = "Unlocked_Level_\(starsCount)"
            
            levelImage.image = UIImage(named: image)
            levelNumber.text = String(level.levelNumber)
            
        }
        else {
            
            levelImage.image = UIImage(named: Images.noLevel)
            levelNumber.text = ""
            
        }
        
    }
}
