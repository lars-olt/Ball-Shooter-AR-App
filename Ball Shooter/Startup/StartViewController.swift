//
//  StartViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 7/2/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit
import CoreData

let defaults = UserDefaults.standard

class StartViewController: UIViewController {

    var playedBefore = false
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the stored bool value
        let hasPlayedBefore = defaults.bool(forKey: Keys.played)
        
        // Update the local variable
        if hasPlayedBefore {
            playedBefore = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the nav controller
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        
        if playedBefore {
            self.performSegue(withIdentifier: "segueFromStartToLevels", sender: self)
        }
        else {
            playedBefore = true
            
            // Save the defaults
            defaults.set(playedBefore, forKey: Keys.played)
            
            // Segure to the introduction screen
            self.performSegue(withIdentifier: "segueFromStartToOnboarding", sender: self)
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
