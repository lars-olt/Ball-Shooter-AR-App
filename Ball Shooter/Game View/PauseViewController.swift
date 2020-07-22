//
//  PauseViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 7/11/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit
import ARKit

var passedText = ""
var initText = false

class PauseViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var scoreToBeatLabel: UILabel!
    
    var score: Int!
    var passedTargetScore: Int!
    var currentLevelNumber: Int!
    var passedHoopCount: Int!
    var passedBallCount: Int!
    var currentLevel: newLevel!
    var currentColor: UIColor!
    var passedBeginningBallCount: Int!
    var loop: GameLoop!
    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScoreLabel.text = "Current Score: \(score!)"
        scoreToBeatLabel.text = "Score to Beat: \(passedTargetScore!)"
        
    }
    
    
    @IBAction func continueBtn(_ sender: Any) {
        print("Continue running")
        // TODO: - Add a tap to continue btn
        passedText = ResumeGame.resumeMsg
        
        guard let gameViewController = storyboard?.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        
        self.dismiss(animated: true) {
            gameStarted = false
            runWithoutSetup = true
        }
        
        gameViewController.resumeLoop()
        
    }
    
    @IBAction func switchLevelBtn(_ sender: Any) {
        print("Switch levels")
        guard let levelsViewController = storyboard?.instantiateViewController(identifier: "LevelsViewController") as? LevelsViewController else { return }
        guard let gameViewController = storyboard?.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        
        gameViewController.loop?.stop()
        hoopArray = [Hoop]()
        
        levelsViewController.modalPresentationStyle = .fullScreen
        present(levelsViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func restartBtn(_ sender: Any) {
        print("Restart level")
        
        passedText = ResumeGame.restartMsg
        initText = true
        
        guard let gameViewController = storyboard?.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        
        self.dismiss(animated: true) {
            gameStarted = false
            runWithoutSetup = true
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
