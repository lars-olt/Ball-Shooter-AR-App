//
//  GameLoop.swift
//  Ball Shooter
//
//  Created by Lars Olt on 6/14/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit

class GameLoop: NSObject {
    
    var funcToRun: () -> ()?
    var updater: CADisplayLink!
    
    init(funcToRun: @escaping () -> ()) {
        self.funcToRun = funcToRun
        super.init()
    }
    
    @objc func gameLoop() {
        funcToRun()
    }
    
    func start() {
        updater = CADisplayLink(target: self, selector: #selector(self.gameLoop))
        updater.preferredFramesPerSecond = 1
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    func stop() {
        updater.invalidate()
        updater.remove(from: RunLoop.current, forMode: RunLoop.Mode.common)
        updater = nil
    }
    
}

