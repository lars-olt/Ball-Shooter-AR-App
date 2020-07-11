//
//  LevelsViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/24/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit

var unlockedLevels = [1]
var levelsStarCount: [Int] = []

class LevelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentLevel: newLevel?
    var model = LevelModel()
    var levelArray = [Level]()
    var level: Level?
    
    let defaults = UserDefaults.standard
    var passedLevelNumber: Int?
    var passedStarCount: Int?
    var nextLevelNumber: Int?
    var didPassLevels = false
    var passedUnlockedLevels: [Int]?
    var passedLevelsStarCount: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLevels()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        levelArray = model.getLevels()
        
        // Fill levels star count
        if (levelsStarCount.count == 0) {
            for _ in 1...15 {
                levelsStarCount.append(0)
            }
        }
        
        print("Levels star count: \(levelsStarCount)")
        
        passedUnlockedLevels = defaults.array(forKey: Keys.unlockedLevels) as? [Int] ?? nil
        passedLevelsStarCount = defaults.array(forKey: Keys.levelsStarCount) as? [Int] ?? nil
        
        if (passedUnlockedLevels != nil && passedLevelsStarCount != nil) {
            didPassLevels = true
            print("passed levels star count: \(passedLevelsStarCount!)")
        }
        
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if didPassLevels {
            unlockedLevels = passedUnlockedLevels!
            levelsStarCount = passedLevelsStarCount!
        }
        
        // Initilizes the level
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as! LevelCollectionViewCell
        let level = levelArray[indexPath.row]
        
        // Sets up the state
        if (level.levelNumber == nextLevelNumber || unlockedLevels.contains(level.levelNumber) || ((passedUnlockedLevels?.contains(level.levelNumber)) != nil)) {
            
            if (didPassLevels == false) {
                unlockedLevels.append(level.levelNumber)
            }
            
            level.isUnlocked = true
            
        }
        
        // Set the update the starcount
        if (levelsStarCount[level.levelNumber - 1] != 0) {
            level.stars = levelsStarCount[level.levelNumber - 1]
        }
        
        // Unlock the next level based on levels passed
        if (passedUnlockedLevels?.contains(level.levelNumber) ?? false && level.stars > 1) {
            let nextLevel = levelArray[indexPath.row + 1]
            nextLevel.isUnlocked = true
        }
        
        // Update the star count for passed values
        if (level.levelNumber == passedLevelNumber) {
            // Get the star count if the user beat the level
            level.stars = passedStarCount!
            levelsStarCount[level.levelNumber - 1] = passedStarCount!
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
            
            // Set up the game view with the choosen level
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
