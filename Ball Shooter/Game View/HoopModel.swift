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

var count = 0
var hoopArray = [Hoop]()
var position: SCNVector3?
var objectSpeed: Int?
var screens = [String]()
var cameraPosition: simd_float4?

func createHoop(sceneView: ARSCNView) {
    
    position = generateRandomPositions(positionsY: yChangeArr)
    
    count += 1
    
    // Create hoops
    let hoop = Hoop(sceneView: sceneView, name: "screen\(count)", position: position!)
    hoop.createHoop()
    
    screens.append("screen\(count)")
    
    // Add the new hoop to the screen
    sceneView.scene.rootNode.addChildNode(newHoop)
    sceneView.scene.rootNode.addChildNode(newScreen)
    
    newHoop.runAction(SCNAction.move(by: SCNVector3(0, 0, 40), duration: TimeInterval(objectSpeed!)))
    newScreen.runAction(SCNAction.move(by: SCNVector3(0, 0, 40), duration: TimeInterval(objectSpeed!)))
    
    hoopArray.append(hoop)
    
}
