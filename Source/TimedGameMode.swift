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
    
    private let highscoreKey = "TimedGameMode.Highschore";
    private var newHighscore = false;
    
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
        let pointsText = "point".pluralize(points);
        if (!newHighscore) {
            let oldHighscore = NSUserDefaults.standardUserDefaults().integerForKey(highscoreKey);
            let oldHighscoreText = "point".pluralize(oldHighscore);
            return "You have scored \(points) \(pointsText)! Your highscore is \(Int(oldHighscore)) \(oldHighscoreText).";
        } else {
            return "You have reached a new highscore of \(points) \(pointsText)!";
        }
    }
    
    func saveHighscore() {
        let oldHigschore = NSUserDefaults.standardUserDefaults().integerForKey(highscoreKey);
        if (points > oldHigschore) {
            // if this score is larger than the old highscore, store it
            NSUserDefaults.standardUserDefaults().setInteger(points, forKey: highscoreKey);
            NSUserDefaults.standardUserDefaults().synchronize();
            newHighscore = true;
        } else {
            newHighscore = false;
        }
    }
    
    /* initializer */
    
    init() {
        // 'self' in this case is the class which implements the protocol
        userInterface = CCBReader.load("TimedModeUI", owner: self);
        updatePointsDisplay(points);
        updateTimeDisplay(time);
    }
    
}
