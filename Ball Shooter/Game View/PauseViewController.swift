//
//  PauseViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 7/11/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit
import ARKit

var initText = false

class PauseViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var scoreToBeatLabel: UILabel!
    
    var score: Int!
    var passedTargetScore: Int!
    var currentLevelNumber: Int!
    var passedBallCount: Int!
    var currentLevel: newLevel!
    var currentColor: UIColor!
    var passedBeginningBallCount: Int!
    var loop: GameLoop!
    var sceneView: ARSCNView!
    var randomColorInterval: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formattedScore = numberFormatter.string(from: NSNumber(value: score)) ?? "Score: "
        let formattedScoreToBeat = numberFormatter.string(from: NSNumber(value: passedTargetScore)) ?? "Score: "
        currentScoreLabel.text = "Current Score: \(formattedScore)"
        scoreToBeatLabel.text = "Score to Beat: \(formattedScoreToBeat)"
    }
    
    
    @IBAction func continueBtn(_ sender: Any) {
        print("Continue running")
        // TODO: - Add a tap to continue btn
        
        guard let gameViewController = storyboard?.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        
        self.dismiss(animated: true) {
            gameStarted = false
            runWithoutSetup = true
            unlockedLevels.append(self.currentLevelNumber + 1)
        }
        gameViewController.randomColorInterval = randomColorInterval
        gameViewController.resumeLoop()
        
    }
    
    @IBAction func switchLevelBtn(_ sender: Any) {
        print("Switch levels")
        guard let levelsViewController = storyboard?.instantiateViewController(identifier: "LevelsViewController") as? LevelsViewController else { return }
        guard let gameViewController = storyboard?.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        
        gameStarted = false
        runWithoutSetup = false
        gameViewController.loop?.stop()
        hoopArray = [Hoop]()
        
        unlockedLevels.append(currentLevelNumber)
        
        if levelsStarCount[currentLevelNumber + 1] >= 2 {
            // If the privious levels star count is greater than 2:
            unlockedLevels.append(currentLevelNumber + 1)
        }
        
        levelsViewController.modalPresentationStyle = .fullScreen
        present(levelsViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func restartBtn(_ sender: Any) {
        print("Restart level")
        
        initText = true
        
        guard let gameViewController = storyboard?.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        
        self.dismiss(animated: true) {
            gameStarted = false
            runWithoutSetup = true
            gameViewController.randomColorInterval = self.randomColorInterval
            gameViewController.viewDidLoad()
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
