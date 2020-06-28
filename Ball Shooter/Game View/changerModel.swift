//
//  HoopModel.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/6/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import QuartzCore

func createChanger(sceneView: ARSCNView, result: ARHitTestResult, color: UIColor) {
    
    var pos: Int?
    
    if leftSide == true {
        pos = -1
    }
    else {
        pos = 1
    }
    
    // Create hoops
    let currentFrame = sceneView.session.currentFrame
    let cameraPosition = currentFrame!.camera.transform.columns.3
    let planePosition = result.worldTransform.columns.3
    position = SCNVector3(cameraPosition.x + Float(pos!), planePosition.y + 1.5, cameraPosition.z - 35)
    
    let changer = ColorChanger(sceneView: sceneView, position: position!, color: color)
    changer.addColorChanger()
    
    // Add the new hoop to the screen
    sceneView.scene.rootNode.addChildNode(changerNode)
    
    changerNode.runAction(SCNAction.move(by: SCNVector3(0, 0, 40), duration: 5))
    
    leftSide = !leftSide
}
