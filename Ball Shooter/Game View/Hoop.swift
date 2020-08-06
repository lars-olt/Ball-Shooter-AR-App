//
//  Hoop.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/6/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

var screenColor = UIColor .cyan
var newHoop = SCNNode()
var newScreen = SCNNode()

class Hoop {
    
    var sceneView: ARSCNView
    var name: String
    var position: SCNVector3
    var wasHit: Bool
    var hoopColor: UIColor?
    
    init(sceneView: ARSCNView, name: String, position: SCNVector3) {
        self.sceneView = sceneView
        self.name = name
        self.position = position
        self.wasHit = false
        self.hoopColor = screenColor
    }
    
    func createHoop() {
        let hoopScene = SCNScene(named: "art.scnassets/hoops.scn")
        let hoopNode = hoopScene?.rootNode.childNode(withName: "ring", recursively: false)?.clone()
        let screenNode = hoopScene?.rootNode.childNode(withName: "plane", recursively: false)?.clone()
        
        // Configure the ring
        hoopNode!.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: hoopNode!))
        hoopNode!.position = position
        
        // Set the screen name based on if the hoop is red or not
        if screenColor == UIColor.red {
            screenNode?.name = "falseHoop"
        }
        else {
            screenNode?.name = name
        }
        
        // Configure the screen
        screenNode?.geometry?.firstMaterial?.diffuse.contents = screenColor
        screenNode!.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: hoopNode!))
        screenNode!.position = position
        screenNode!.physicsBody?.categoryBitMask = BodyType.screen.rawValue
        screenNode!.physicsBody?.contactTestBitMask = BodyType.ball.rawValue
        
        if screenColor == UIColor .red { // Lower opacuty for red hoops
            screenNode?.opacity = 0.5
        }
        
        // Set the rotation of the hoop
        hoopNode!.eulerAngles.y = cameraRotation!
        screenNode!.eulerAngles.y = cameraRotation!
        
        newHoop = hoopNode!
        newScreen = screenNode!
    }
    
}
