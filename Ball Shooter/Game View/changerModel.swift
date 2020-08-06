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

func createChanger(sceneView: ARSCNView, color: UIColor) {
    // Create changer
    position = generateRandomPositions(positionsY: yChangeArr)
    
    let changer = ColorChanger(sceneView: sceneView, position: position!, color: color)
    changer.addColorChanger()
    
    // Add the new hoop to the screen
    sceneView.scene.rootNode.addChildNode(changerNode)
    
    changerNode.runAction(SCNAction.move(by: SCNVector3(0, 0, 40), duration: TimeInterval(objectSpeed!)))
    
}
