//
//  Ball.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/7/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

var ballColor = UIColor .blue
var ballNode: SCNNode?

class Ball {
    
    var sceneView: ARSCNView
    var cameraTransform: SCNMatrix4
    var currentFrame: ARFrame
    var ball: SCNNode
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        currentFrame = sceneView.session.currentFrame!
        self.cameraTransform = SCNMatrix4(currentFrame.camera.transform)
        ball = SCNNode(geometry: SCNSphere(radius: 0.1))
    }
    
    func createBall() {
        
        ball.name = "Visibleball"
        ball.geometry?.firstMaterial?.diffuse.contents = ballColor
        ball.transform = cameraTransform
        ball.position = SCNVector3Make(0, -0.8, -2)
        
        sceneView.pointOfView?.addChildNode(ball)
    }
    
    func throwBall() {
        
        ball.name = "ball"
        ball.transform = cameraTransform
        ball.geometry?.firstMaterial?.diffuse.contents = ballColor
        ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball))
        ball.physicsBody?.categoryBitMask = BodyType.ball.rawValue
        ball.physicsBody?.collisionBitMask = BodyType.ball.rawValue
        ball.physicsBody?.contactTestBitMask = BodyType.screen.rawValue
        ball.physicsBody?.contactTestBitMask = BodyType.colorChanger.rawValue
        let power = Float(30.0)
        let force = SCNVector3(-cameraTransform.m31 * power, -cameraTransform.m32 * power * 1.5, -cameraTransform.m33 * power)
        ball.position = SCNVector3Make(0, -0.8, -2)
        ball.physicsBody?.applyForce(force, asImpulse: true)
        sceneView.pointOfView?.addChildNode(ball)
        ballNode = ball
        
    }
    
}

