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
    var currentLevel: newLevel!
    var currentLevelNumber: Int!
    var randomColorInterval: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        
        switch score {
            
            case _ where score < TargetScore.noStars:
                levelStarCount = 0
                finalStarsCount.image = UIImage(named: FinalStars.star_0)
                message = Message.loose
                
            case _ where score < currentLevel.oneStarScore:
                levelStarCount = 1
                finalStarsCount.image = UIImage(named: FinalStars.star_1)
                message = Message.loose
                
            case _ where score < currentLevel.twoStarsScore:
                levelStarCount = 2
                finalStarsCount.image = UIImage(named: FinalStars.star_2)
                message = Message.win
                
            case _ where score == currentLevel.threeStarsScore:
                levelStarCount = 3
                finalStarsCount.image = UIImage(named: FinalStars.star_3)
                message = Message.win
                
            default:
                print("Score count is out of range")
                levelStarCount = 0
                finalStarsCount.image = UIImage(named: FinalStars.star_0)
                message = Message.win
            
        }
        
        textDisplayed.text = message
        let formattedScore = numberFormatter.string(from: NSNumber(value: score)) ?? "Score: "
        let formattedScoreToBeat = numberFormatter.string(from: NSNumber(value: passedTargetScore)) ?? "Score: "
        scoreDisplayed.text = "Score: \(formattedScore)"
        targetScore.text = "Score to Beat: \(formattedScoreToBeat)"
        
        // Set the next level btn
        if levelStarCount! >= 2 {
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
                currentLevelBallCount = gameViewController.currentLevel.ballCount
                gameViewController.ballCount = currentLevelBallCount!
                gameViewController.hoopInterval = gameViewController.currentLevel.hoopInterval
                gameViewController.changerInterval = gameViewController.currentLevel.changerInterval
                objectSpeed = gameViewController.currentLevel.objectSpeed
                gameViewController.oneStarScore = gameViewController.currentLevel.oneStarScore
                gameViewController.twoStarScore = gameViewController.currentLevel.twoStarsScore
                gameViewController.threeStarScore = gameViewController.currentLevel.threeStarsScore
                gameViewController.randomColorInterval = gameViewController.currentLevel.randomColorInterval
                
                gameStarted = false
                
                // Set up the levels view
                unlockedLevels.append(currentLevelNumber)
                unlockedLevels.append(currentLevelNumber + 1)
                
                levelsStarCount[currentLevelNumber - 1] = levelStarCount!
                
                saveDefaults()
                
                // Perform the segue
                gameViewController.modalPresentationStyle = .fullScreen
                present(gameViewController, animated: false, completion: nil)
                
            }
            
        }
        
    }
    
    @IBAction func switchLevelBtnPressed(_ sender: Any) {
        
        // Segue to the levels view
        guard let levelsViewController = storyboard?.instantiateViewController(withIdentifier: "LevelsViewController") as? LevelsViewController else {return}
        
        // Set the starcount on the current level
        levelsViewController.passedLevelNumber = currentLevelNumber
        levelsViewController.passedStarCount = levelStarCount
        
        // Unlock the next level
        if levelStarCount != 1 {
            levelsViewController.nextLevelNumber = currentLevelNumber + 1
        }
        
        // Set up the level for the levels view
        print("Current Level Number: \(currentLevelNumber)")
        unlockedLevels.append(currentLevelNumber)
        unlockedLevels.append(currentLevelNumber + 1)
        
        levelsStarCount[currentLevelNumber - 1] = levelStarCount!
        
        saveDefaults()
        
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
        gameViewController.hoopInterval = currentLevel?.hoopInterval
        gameViewController.changerInterval = currentLevel?.changerInterval
        objectSpeed = currentLevel?.objectSpeed
        gameViewController.oneStarScore = currentLevel?.oneStarScore
        gameViewController.twoStarScore = currentLevel?.twoStarsScore
        gameViewController.threeStarScore = currentLevel?.threeStarsScore
        gameViewController.randomColorInterval = randomColorInterval
        
        gameStarted = false
        
        // Set up the level for the levels view
        levelsStarCount[currentLevelNumber] = levelStarCount!
        
        saveDefaults()
        
        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: false, completion: nil)
        
    }
    
    func saveDefaults() {
        defaults.setValue(unlockedLevels, forKey: Keys.unlockedLevels)
        defaults.setValue(levelsStarCount, forKey: Keys.levelsStarCount)
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
