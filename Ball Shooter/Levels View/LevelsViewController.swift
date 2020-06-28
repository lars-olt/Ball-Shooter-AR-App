//
//  LevelsViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/24/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit

class LevelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentLevel: newLevel?
    var model = LevelModel()
    var levelArray = [Level]()
    var level: Level?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if (indexPath.row + 1 == 1 && !gameStarted) {
            level.isUnlocked = true
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
            
            switch level!.levelNumber {
                
            case 1:
                currentLevel = level1
            default:
                print("Level could not be found")
                
            }
            
            
            // Initilize the game for the current level
            gameViewController.currentGameLevel = currentLevel
            gameViewController.ballCount = currentLevel?.ballCount
            gameViewController.hoopCount = currentLevel?.hoopCount
            gameViewController.hoopInterval = currentLevel?.hoopInterval
            gameViewController.changerInterval = currentLevel?.changerInterval
            objectSpeed = currentLevel?.objectSpeed
            gameViewController.oneStarScore = currentLevel?.oneStarScore
            gameViewController.twoStarScore = currentLevel?.twoStarsScore
            gameViewController.threeStarScore = currentLevel?.threeStarsScore
            
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
