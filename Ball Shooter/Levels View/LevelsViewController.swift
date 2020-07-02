//
//  LevelsViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/24/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit

var unlockedLevels = [1]
var levelsStarCount: [Int: Int] = [:]

class LevelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentLevel: newLevel?
    var model = LevelModel()
    var levelArray = [Level]()
    var level: Level?
    
    var passedLevelNumber: Int?
    var passedStarCount: Int?
    var nextLevelNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLevels()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        levelArray = model.getLevels()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Initilizes the level
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as! LevelCollectionViewCell
        let level = levelArray[indexPath.row]
         
        // Sets up the state
        if (level.levelNumber == nextLevelNumber || unlockedLevels.contains(level.levelNumber)) {
            unlockedLevels.append(level.levelNumber)
            level.isUnlocked = true
        }
        
        // Set the update the starcount
        if (levelsStarCount.count != 0 && levelsStarCount[level.levelNumber] != nil) {
            level.stars = levelsStarCount[level.levelNumber]!
        }
        
        // Update the star count and store those values
        if (level.levelNumber == passedLevelNumber) {
            // Get the star count if the user beat the level
            level.stars = passedStarCount!
            levelsStarCount[level.levelNumber] = passedStarCount!
        }
        
        cell.setLevel(level)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let cell = collectionView.cellForItem(at: indexPath) as! LevelCollectionViewCell
        level = levelArray[indexPath.row]
        
        if level!.isUnlocked {
            
            // Perform a modal segue to the game view
            self.performSegue(withIdentifier: "beginGame", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "beginGame") {
            
            guard let gameViewController = segue.destination as? GameViewController else {return}
            
            currentLevel = levels[level!.levelNumber]
            
            // Initilize the game for the current level
            gameViewController.currentLevel = currentLevel
            gameViewController.currentLevelNumber = level!.levelNumber
            gameViewController.ballCount = currentLevel?.ballCount
            gameViewController.hoopCount = currentLevel?.hoopCount
            gameViewController.hoopInterval = currentLevel?.hoopInterval
            gameViewController.changerInterval = currentLevel?.changerInterval
            objectSpeed = currentLevel?.objectSpeed
            gameViewController.oneStarScore = currentLevel?.oneStarScore
            gameViewController.twoStarScore = currentLevel?.twoStarsScore
            gameViewController.threeStarScore = currentLevel?.threeStarsScore
            
            gameStarted = false
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
