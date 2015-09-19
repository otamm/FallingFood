//
//  GameMode.swift
//  FallingFood
//
//  Created by Otavio Monteagudo on 9/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

typealias GameOver = Bool;

protocol GameMode: class {
    var userInterface: CCNode! { get }
    
    func gameplay(mainScene:MainScene, droppedFallingObject:FallingObject);
    
    func gameplay(mainScene:MainScene, caughtFallingObject:FallingObject);
    
    func gameplayStep(mainScene:MainScene, delta: CCTime) -> GameOver;
}
