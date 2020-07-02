//
//  ViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 5/29/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

var cameraRotation: Float?
var gameStarted = false

enum BodyType: Int {
    case screen = 1
    case ball = 4
    case hoop = 6
    case colorChanger = 8
}

class GameViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    // Declirations to assign the level
    var currentLevel: newLevel!
    var ballCount: Int!
    var hoopCount: Int!
    var hoopInterval: Int!
    var changerInterval: Int!
    var oneStarScore: Int!
    var twoStarScore: Int!
    var threeStarScore: Int!
    var currentLevelNumber: Int!
    
    
    var floorUsed = false
    var loop: GameLoop?
    var start: DispatchTime?
    var displayLink: CADisplayLink!
    var score = 0
    var touchResult: ARHitTestResult?
    var ball: Ball?
    var currentColor: UIColor?
    var currentBallColor: UIColor?
    var bounds = UIScreen.main.bounds
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var didWin = false

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballsRemainingLabel: UILabel!
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(.random(in: 0...0.5)), blue: CGFloat(drand48()), alpha: 1.0)
    }
    
    @objc func runHoops() { // Game loop
        
        if gameStarted == true {
            
            let time = getTime()
            
            if (hoopCount == 0 && score < oneStarScore || ballCount == 0 && score < oneStarScore){
                // One star
                // Player did not pass the level
                
                didWin = false
                
                self.performSegue(withIdentifier: "displayResults", sender: self)
                
            }
                
            else if (hoopCount == 0 && score < twoStarScore || ballCount == 0 && score < twoStarScore) {
                // Two stars
                // Player has passed the level
                
                didWin = true
                
                self.performSegue(withIdentifier: "displayResults", sender: self)
                
            }
                
            else if (hoopCount == 0 && score == threeStarScore || ballCount == 0 && score == threeStarScore) {
                // Three stars
                // Player gets all 3 stars
                
                didWin = true
                
                self.performSegue(withIdentifier: "displayResults", sender: self)
                
            }
            
            else if (time % changerInterval == objectSpeed && currentColor != currentBallColor)  {
                
                // Player did not pass the level
                if score > oneStarScore {
                    didWin = false
                }
                else {
                    didWin = true
                }
                
                self.performSegue(withIdentifier: "displayResults", sender: self)
                
            }
            else if (time % hoopInterval == 0 && hoopCount != 0 && ballCount != 0 && currentColor == currentBallColor) {
                
                // Add a color changer to the screen
                if time % changerInterval == 0 && time != 0 {
                    
                    currentColor = randomColor()
                    createChanger(sceneView: sceneView, result: touchResult!, color: currentColor!)
                    
                    // Update the color of the ring
                    screenColor = currentColor!
                    
                } else { // Add a hoop to the screen
                    
                    createHoop(sceneView: sceneView, result: touchResult!)
                    hoopCount -= 1
                    
                }
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentColor = UIColor .cyan
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.scene.physicsWorld.contactDelegate = self
        
        // Set up the score label
        scoreLabel.text = "Score: \(score)"
        
        // Set up the ball count label
        ballsRemainingLabel.text = "Balls Remaining: \(ballCount!)"
        
    }
    
    func getTime() -> Int {
        let now = DispatchTime.now()
        let time = now.uptimeNanoseconds - start!.uptimeNanoseconds
        let currentTime = (Double(time) / 1_000_000_000)
        
        return Int(currentTime)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if (contact.nodeA.name != "ball" && contact.nodeA.name != "floor" && contact.nodeA.name != "colorChanger" && contact.nodeA.name != "Visibleball") {
            
            for hoop in hoopArray{
                if hoop.name == contact.nodeA.name && hoop.wasHit == false {
                    if (hoop.hoopColor == currentBallColor) {
                        hoop.wasHit = true
                        
                        contact.nodeA.geometry?.firstMaterial?.diffuse.contents = UIColor .green
                        
                        score += 600
                        DispatchQueue.main.async {
                            self.scoreLabel.text = "Score: \(self.score)"
                        }
                    }
                    
                }
                
            }
            
            
        }
        
        if(contact.nodeA.name == "colorChanger") {
            
            // Change the ball that made contact
            print("Switching colors...")
            contact.nodeA.removeFromParentNode()
            
            // Current color is updated for the color of the changer
            currentBallColor = currentColor
            
            // Change the upcomming balls and screen color
            ballColor = currentBallColor!
            screenColor = currentColor!
            
            // Change the visible ball
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "Visibleball" {
                    node.geometry?.firstMaterial?.diffuse.contents = currentBallColor
                }
            }
            
            
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            
            if (node.name == "ball") {
                
                if (node.presentation.position.y < -30) {
                    
                    node.removeFromParentNode()
                    
                }
                
            }
            
            if (node.name != "ball" && node.name != "hoop" && node.name != "floor") {
                
                if (node.presentation.position.z > 1) {
                    
                    node.removeFromParentNode()
                    
                }
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        
        // Initiate the ball
        ball = Ball(sceneView: sceneView)
        
        // Check for first click to difine floor
        if !gameStarted {
            let touchLocation = sender.location(in: sceneView)
            let hitTestResult = sceneView.hitTest(touchLocation, types: [.existingPlane])
            
            if let result = hitTestResult.first {
                
                // Set starting colors
                currentColor = UIColor .cyan
                screenColor = currentColor!
                currentBallColor = currentColor
                
                // Begin keeping track of time
                start = DispatchTime.now()
                
                sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == "floor" {
                        floorUsed = true
                        node.removeFromParentNode()
                    }
                }
                
                touchResult = result
                
                let currentFrame = sceneView.session.currentFrame
                cameraRotation = currentFrame!.camera.eulerAngles.y
                
                // Initialize game start
                gameStarted = true
                
                sceneView.debugOptions = []
                
                loop = GameLoop(funcToRun: runHoops)
                loop!.start()
                
                ballColor = currentBallColor!
                
                ball?.createBall()
            }
        }
        else { // All other clicks
            
            // Shoot a ball if player still has balls
            if (ballCount != 0) {
                ballCount -= 1
                ballsRemainingLabel.text = "Balls Remaining: \(ballCount!)"
                ballColor = currentBallColor!
                ball?.throwBall()
            }
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if self.floorUsed == false {
                guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
                let floor = self.createFloor(planeAnchor: planeAnchor)
                node.addChildNode(floor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            for node in node.childNodes {
                node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                if let plane = node.geometry as? SCNPlane {
                    plane.width = CGFloat(planeAnchor.extent.x)
                    plane.height = CGFloat(planeAnchor.extent.z)
                }
            }
        }
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
            let node = SCNNode()
            let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            node.geometry = geometry
            node.eulerAngles.x = -Float.pi / 2
            node.opacity = 0.5
            node.name = "floor"
            return node
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "displayResults" {
            
            loop?.stop()
            
            guard let resultsViewController = segue.destination as? ResultsViewController else { return }
            
            resultsViewController.currentLevelNumber = currentLevelNumber
            resultsViewController.currentLevel = currentLevel
            resultsViewController.score = score
            resultsViewController.passedTargetScore = currentLevel.threeStarsScore
            
            print("Did win: \(didWin)")
            
            if (didWin) {
                resultsViewController.message = Message.win
                resultsViewController.nextLevelBtnOn = true
            }
            else {
                resultsViewController.message = Message.loose
                resultsViewController.nextLevelBtnOn = false
            }
        }
    }
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
