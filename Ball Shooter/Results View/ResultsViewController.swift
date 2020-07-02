//
//  ResultsViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/25/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit

var levelStarCount: Int?

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var textDisplayed: UILabel!
    @IBOutlet weak var finalStarsCount: UIImageView!
    @IBOutlet weak var nextLevelBtn: UIButton!
    @IBOutlet weak var scoreDisplayed: UILabel!
    @IBOutlet weak var targetScore: UILabel!
    
    var score: Int!
    var passedTargetScore: Int!
    var message: String!
    var nextLevelBtnOn = false
    var currentLevel: newLevel!
    var currentLevelNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        
        switch score {
            
            case _ where score < TargetScore.noStars:
                levelStarCount = 0
                finalStarsCount.image = UIImage(named: FinalStars.star_0)
                
            case _ where score < currentLevel.oneStarScore:
                levelStarCount = 1
                finalStarsCount.image = UIImage(named: FinalStars.star_1)
                
            case _ where score < currentLevel.twoStarsScore:
                levelStarCount = 2
                finalStarsCount.image = UIImage(named: FinalStars.star_2)
                
            case _ where score == currentLevel.threeStarsScore:
                levelStarCount = 3
                finalStarsCount.image = UIImage(named: FinalStars.star_3)
                
            default:
                print("Score count is out of range")
                levelStarCount = 0
                finalStarsCount.image = UIImage(named: FinalStars.star_0)
            
        }
        
        textDisplayed.text = message
        scoreDisplayed.text = "Score: \(String(score))"
        targetScore.text = "Score to Best: \(String(passedTargetScore))"
        
        if (nextLevelBtnOn) {
            nextLevelBtn.setBackgroundImage(UIImage(named: Images.nextLevelBtnOn), for: UIControl.State.normal)
        }
        else {
            nextLevelBtn.setBackgroundImage(UIImage(named: Images.nextLevelBtnOff), for: UIControl.State.normal)
        }
        
    }
    
    @IBAction func nextLevelBtnPressed(_ sender: Any) {
        
        if (levelStarCount! > 1) {
            // Switch levels
            
            guard let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
            
            // Initilize the game for the next level
            if (currentLevelNumber + 1 <= (levels.count)) { // Check for last
                let nextLevelIndex = currentLevelNumber!
                let nextLevel = levels[nextLevelIndex]
                
                gameViewController.currentLevel = nextLevel
                gameViewController.currentLevelNumber = currentLevelNumber + 1
                gameViewController.ballCount = gameViewController.currentLevel.ballCount
                gameViewController.hoopCount = gameViewController.currentLevel.hoopCount
                gameViewController.hoopInterval = gameViewController.currentLevel.hoopInterval
                gameViewController.changerInterval = gameViewController.currentLevel.changerInterval
                objectSpeed = gameViewController.currentLevel.objectSpeed
                gameViewController.oneStarScore = gameViewController.currentLevel.oneStarScore
                gameViewController.twoStarScore = gameViewController.currentLevel.twoStarsScore
                gameViewController.threeStarScore = gameViewController.currentLevel.threeStarsScore
                
                gameStarted = false
                
                // Set up the level for the levels view
                unlockedLevels.append(currentLevelNumber)
                
                if let pastLevelStarCount = levelsStarCount[currentLevelNumber] {
                    
                    if pastLevelStarCount < levelStarCount! {
                        levelsStarCount[currentLevelNumber] = levelStarCount
                    }
                    
                }
                else {
                    levelsStarCount[currentLevelNumber] = levelStarCount
                }
                
                // Perform the segue
                gameViewController.modalPresentationStyle = .fullScreen
                present(gameViewController, animated: false, completion: nil)
                
            }
            
        }
        
    }
    
    @IBAction func switchLevelBtnPressed(_ sender: Any) {
        
        // Segue to the levels view
        guard let levelsViewController = storyboard?.instantiateViewController(withIdentifier: "LevelSelectionView") as? LevelsViewController else {return}
        
        // Set the starcount on the current level
        levelsViewController.passedLevelNumber = currentLevelNumber
        levelsViewController.passedStarCount = levelStarCount
        
        // Unlock the next level
        if levelStarCount != 1 {
            levelsViewController.nextLevelNumber = currentLevelNumber + 1
        }
        
        // Set up the level for the levels view
        unlockedLevels.append(currentLevelNumber)
        
        if let pastLevelStarCount = levelsStarCount[currentLevelNumber] {
            
            if pastLevelStarCount < levelStarCount! {
                levelsStarCount[currentLevelNumber] = levelStarCount
            }
            
        }
        else {
            levelsStarCount[currentLevelNumber] = levelStarCount
        }
        
        levelsViewController.modalPresentationStyle = .fullScreen
        present(levelsViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func restartBtnPressed(_ sender: Any) {
        
        // Reset the level and start the game over again
        guard let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        
        // Initilize the game for the current level
        gameViewController.currentLevel = currentLevel
        gameViewController.currentLevelNumber = currentLevelNumber
        gameViewController.ballCount = currentLevel?.ballCount
        gameViewController.hoopCount = currentLevel?.hoopCount
        gameViewController.hoopInterval = currentLevel?.hoopInterval
        gameViewController.changerInterval = currentLevel?.changerInterval
        objectSpeed = currentLevel?.objectSpeed
        gameViewController.oneStarScore = currentLevel?.oneStarScore
        gameViewController.twoStarScore = currentLevel?.twoStarsScore
        gameViewController.threeStarScore = currentLevel?.threeStarsScore
        
        gameStarted = false
        
        // Set up the level for the levels view
        
        if let pastLevelStarCount = levelsStarCount[currentLevelNumber] {
            
            if pastLevelStarCount < levelStarCount! {
                levelsStarCount[currentLevelNumber] = levelStarCount
            }
            
        }
        else {
            levelsStarCount[currentLevelNumber] = levelStarCount
        }
        
        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: false, completion: nil)
        
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
