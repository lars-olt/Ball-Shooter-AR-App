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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        
        switch score {
            
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
    }
    
    @IBAction func restartBtnPressed(_ sender: Any) {
    }
    
    @IBAction func switchLevelBtnPressed(_ sender: Any) {
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
