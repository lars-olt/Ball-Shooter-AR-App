//
//  ObjectPosition.swift
//  Ball Shooter
//
//  Created by Lars Olt on 8/4/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import Foundation
import SceneKit

func generateRandomPositions(positionsY: [Double]) -> SCNVector3 {
    
    let positionsX = [-3, -1, 1, 3]
    
    let randomIndexX = arc4random_uniform(UInt32(positionsX.count))
    let randomIndexY = arc4random_uniform(UInt32(positionsY.count))
    let posX = positionsX[Int(randomIndexX)]
    let posY = positionsY[Int(randomIndexY)]
    
    return SCNVector3(cameraPosition!.x + Float(posX), cameraPosition!.y + 1 + Float(posY), cameraPosition!.z - 35)
}
