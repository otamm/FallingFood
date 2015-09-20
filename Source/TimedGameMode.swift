//
//  TimedGameMode.swift
//  FallingFood
//
//  Created by Otavio Monteagudo on 9/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

// makes the class visible to Cocos2d, which is written in Obj-C
@objc(TimedGameMode)

class TimedGameMode: GameMode {
    // label on the upper-left side of the screen
    var timeLabel: CCLabelTTF!;
    // label on the upper-right side of the screen
    var pointsLabel: CCLabelTTF!;
    
    let minPoints = 0;
    
    let minTime = 0.0;
    
    // will store the CCB file associated with the game mode; in this case, 'TimedModeUI'
    private(set) var userInterface: CCNode!;
    
    private var time: CCTime = 10 {
        didSet {
            updateTimeDisplay(time);
        }
    }
    private var points: Int = 0 {
        didSet {
            updatePointsDisplay(points);
        }
    }
    
    /* implementing protocol methods */
    
    func updatePointsDisplay(points: Int) {
        // an owner var, actually belongs to MainScene (where the gameplay occurs);
        pointsLabel.string = "Points: \(points)";
    }
    
    func updateTimeDisplay(time: CCTime) {
        timeLabel.string = "Time: \(Int(time))";
    }
    
    
    func gameplay(mainScene:MainScene, droppedFallingObject:FallingObject) {
        if (droppedFallingObject.type == .Good) {
            // loses points if a 'good' object is dropped
            points = max(points - 1, minPoints);
        }
    }
    
    func gameplay(mainScene:MainScene, caughtFallingObject:FallingObject) {
        switch (caughtFallingObject.type) {
            case .Bad:
                points = max(points - 1, minPoints);
            case .Good:
                points += 1;
        }
    }
    
    // subtracts time passed from initial game time, returns 'true' once time is over, which ends the game.
    func gameplayStep(mainScene: MainScene, delta: CCTime) -> GameOver {
        time -= delta;
        return !(time > minTime);
    }
    
    
    func highscoreMessage() -> String {
        // used to check whether or not pluralization is necessary
        let pointsText = points == 1 ? "point" : "points";
        return "You have scored \(Int(points)) \(pointsText)!";
    }
    
    /* initializer */
    
    init() {
        // 'self' in this case is the class which implements the protocol
        userInterface = CCBReader.load("TimedModeUI", owner: self);
        updatePointsDisplay(points);
        updateTimeDisplay(time);
    }
    
}
