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

var leftSide = true
var count = 0
var hoopArray = [Hoop]()
var position: SCNVector3?
var objectSpeed: Int?

func createHoop(sceneView: ARSCNView, result: ARHitTestResult) {
    
    var pos: Int?
    count += 1
    
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
    
    let hoop = Hoop(sceneView: sceneView, name: "screen\(count)", position: position!)
    hoop.createHoop()
    
    // Add the new hoop to the screen
    sceneView.scene.rootNode.addChildNode(newHoop)
    sceneView.scene.rootNode.addChildNode(newScreen)
    
    newHoop.runAction(SCNAction.move(by: SCNVector3(0, 0, 40), duration: TimeInterval(objectSpeed!)))
    newScreen.runAction(SCNAction.move(by: SCNVector3(0, 0, 40), duration: TimeInterval(objectSpeed!)))
    
    hoopArray.append(hoop)
    
    print(hoopArray)
    
    leftSide = !leftSide
}
