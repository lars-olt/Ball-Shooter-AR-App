//
//  ColorChanger.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/18/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import Foundation
import ARKit

var changerNode = SCNNode()

class ColorChanger {
    
    var sceneView: ARSCNView
    var position: SCNVector3
    var color: UIColor
    
    init(sceneView: ARSCNView, position: SCNVector3, color: UIColor) {
        self.sceneView = sceneView
        self.position = position
        self.color = color
    }
    
    func addColorChanger() {
        let colorChangerScene = SCNScene(named: "art.scnassets/ColorChanger.scn")
        let colorChangerNode = colorChangerScene?.rootNode.childNode(withName: "changer", recursively: false)?.clone()
        
        colorChangerNode!.name = "colorChanger"
        colorChangerNode!.position = position
        colorChangerNode!.geometry?.firstMaterial?.diffuse.contents = color
        
        colorChangerNode!.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: colorChangerNode!))
        colorChangerNode!.physicsBody?.categoryBitMask = BodyType.colorChanger.rawValue
        colorChangerNode!.physicsBody?.collisionBitMask = BodyType.ball.rawValue
        
        changerNode = colorChangerNode!
        
    }
    
}
