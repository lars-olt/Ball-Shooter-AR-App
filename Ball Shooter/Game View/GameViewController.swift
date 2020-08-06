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
var scene: ARSCNView?
var runWithoutSetup = false
let numberFormatter = NumberFormatter()
var yChangeArr = [Double]()

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
    var hoopInterval: Int!
    var changerInterval: Int!
    var randomColorInterval: Int!
    var oneStarScore: Int!
    var twoStarScore: Int!
    var threeStarScore: Int!
    var currentLevelNumber: Int!
    var yIncrease: Double!
    
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
    let colors = ["DarkPink", "LightBlue", "LightOrange", "LightPink", "LightPurple", "LightYellow", "MidOrange", "MidPink"]
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballsRemainingLabel: UILabel!
    @IBOutlet weak var gamePausedGraphic: UIImageView!
    @IBOutlet weak var gamePausedText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentColor = UIColor .cyan
        
        // Set the change increase in the y axis
        yChangeArr = [0.0]
        yChangeArr.append(-yIncrease)
        yChangeArr.append(yIncrease)
        print(yChangeArr)
        
        if !runWithoutSetup {
            gamePausedGraphic.isHidden = true
            
            // Set the view's delegate
            sceneView.delegate = self
            
            // Show statistics such as fps and timing information
//            sceneView.showsStatistics = true
//            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
            sceneView.scene.physicsWorld.contactDelegate = self
        }
        
        // Fill levels star count
        if (levelsStarCount.count == 0) {
            for _ in 1...15 {
                levelsStarCount.append(0)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gamePausedGraphic.isHidden = false
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        // Remove any extra hoops from the screen
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            
            if node.name == "ring" {
                node.removeFromParentNode()
            }
            
            for name in screens {
                if node.name == name {
                    node.removeFromParentNode()
                }
            }
        }
        
        // Init the game to be restarted
        if initText {
            
            // Init values
            score = 0
            ballCount = currentLevel.ballCount
            currentColor = UIColor .cyan
            currentBallColor = currentColor
            
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "Visibleball" {
                    node.removeFromParentNode()
                }
            }
            
            initText = false
        }
        
        // Set the pause screen text
        gamePausedText.text = "Start Game"
        
        let configuration = ARWorldTrackingConfiguration() // Create a session configuration
        sceneView.session.run(configuration) // Run the view's session
        
        // Display the initial score and ball count
        scoreLabel.text = getFormattedScore()
        ballsRemainingLabel.text = getFormattedBallCount()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "Visibleball" {
                node.removeFromParentNode()
            }
        }
    }
    
    func getFormattedScore() -> String {
        let formattedScore = numberFormatter.string(from: NSNumber(value: score)) ?? "Score: "
        return "Score: \(formattedScore)"
    }
    
    func getFormattedBallCount() -> String {
        let formattedBallCount = numberFormatter.string(from: NSNumber(value: ballCount!)) ?? "Balls Remaining: "
        return "Balls Remaining: \(formattedBallCount)"
    }
    
    func randomColor() -> UIColor {
        let index = arc4random_uniform(UInt32(colors.count - 1))
        let name = colors[Int(index)]
        return UIColor.init(named: name)!
    }
    
    func resumeLoop() {
        loop?.updater.isPaused = false
        sceneView = scene!
    }
    
    func playerWon() {
        
        didWin = true
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "displayResults", sender: self)
        }
    }
    
    func playerLost() {
        
        didWin = false
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "displayResults", sender: self)
        }
    }
    
    @objc func runHoops() { // Game loop
        
        // Check for game end
        if gameStarted == true {
            
            let time = getTime()
            
            if (ballCount == 0 && score < oneStarScore){
                // One star
                // Player did not pass the level
                
                playerLost()
                
            }
            else if (ballCount == 0 && score < twoStarScore) {
                // Two stars
                // Player has passed the level
                
                playerWon()
                
            }
            else if (score == threeStarScore) {
                // Three stars
                // Player gets all 3 stars
                
                playerWon()
                
            }
            else if (time % changerInterval == objectSpeed && currentColor != currentBallColor)  {
                // If the hoop has made it to the player and the color hasnt been changed
                // Player did not pass the level
                
                if score > oneStarScore {
                    didWin = true
                }
                else {
                    didWin = false
                }
                
                self.performSegue(withIdentifier: "displayResults", sender: self)
                
            }
            else if (time % hoopInterval == 0 && ballCount != 0 && currentColor == currentBallColor) {
                // Add a hoop or changer to the screen
                
                if time != 0 && time % changerInterval == 0 {
                    // Add a color changer to the screen
                    currentColor = randomColor()
                    createChanger(sceneView: sceneView, color: currentColor!)
                    
                    // Update the color of the ring
                    screenColor = currentColor!
                    
                } else { // Add a hoop to the screen
                    // Check for random color
                    if time != 0 && time % randomColorInterval == 0 {
                        screenColor = UIColor.red
                        createHoop(sceneView: sceneView)
                        screenColor = currentColor! // Reset color
                    }
                    else {
                        createHoop(sceneView: sceneView)
                    }
                }
                
            }
            
        }
        
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        
        if loop != nil { // Setup and perform segue
            loop?.updater.isPaused = !(loop?.updater.isPaused)!
            self.performSegue(withIdentifier: "pauseSegue", sender: self)
        }
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
                            self.scoreLabel.text = self.getFormattedScore()
                        }
                    }
                    else { // Colors did not match
                        
                        hoop.wasHit = true
                        
                        contact.nodeA.opacity = 1
                        
                        score -= 300
                        DispatchQueue.main.async {
                            self.scoreLabel.text = self.getFormattedScore()
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
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        
        // Initiate the ball
        ball = Ball(sceneView: sceneView)
        gamePausedGraphic.isHidden = true
        gamePausedText.text = ""
        
        // Check for first click to difine floor
        if !gameStarted {
            
            // Set starting colors
            currentColor = UIColor .cyan
            screenColor = currentColor!
            currentBallColor = currentColor
            
            // Begin keeping track of time
            start = DispatchTime.now()
            
            // Set up the position and rotation
            let currentFrame = sceneView.session.currentFrame
            cameraPosition = currentFrame!.camera.transform.columns.3
            cameraRotation = currentFrame!.camera.eulerAngles.y
            
            // Initialize game start
            gameStarted = true
            
            loop = GameLoop(funcToRun: runHoops)
            loop!.start()
            
            ballColor = currentBallColor!
            
            ballCount -= 1
            ballsRemainingLabel.text = getFormattedBallCount()
            ball?.createBall()
            
        }
        else { // All other clicks
            
            // Shoot a ball if player still has balls
            if (ballCount != 0) {
                ballCount -= 1
                ballsRemainingLabel.text = getFormattedBallCount()
                ballColor = currentBallColor!
                ball?.throwBall()
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
            
            if (node.name != "ball" && node.name != "hoop") {
                
                if (node.presentation.position.z > 1) {
                    
                    for hoop in hoopArray{ // Check if the hoop was hit
                        if hoop.name != "falseHoop" {
                            if hoop.name == node.name && hoop.wasHit == false {
                                
                                // Hoop that was not hit passed the player
                                playerLost()
                                
                            }
                        }
                    }
                    
                    // Remove it from the view
                    node.removeFromParentNode()
                    
                }
                
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
            resultsViewController.randomColorInterval = randomColorInterval
            
            print("Did win: \(didWin)")
            
        }
        else if segue.identifier == "pauseSegue" {
            
            loop?.updater.isPaused = true
            
            scene = sceneView
            
            guard let pauseViewController = segue.destination as? PauseViewController else { return }
            
            pauseViewController.passedBallCount = ballCount
            pauseViewController.currentLevelNumber = currentLevelNumber
            pauseViewController.currentLevel = currentLevel
            pauseViewController.currentColor = currentColor
            pauseViewController.score = score
            pauseViewController.passedTargetScore = currentLevel.threeStarsScore
            pauseViewController.loop = loop
            pauseViewController.passedBeginningBallCount = currentLevel.ballCount
            pauseViewController.sceneView = sceneView
            pauseViewController.randomColorInterval = randomColorInterval
            
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

