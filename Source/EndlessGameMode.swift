//
//  EndlessGameMode.swift
//  FallingFood
//
//  Created by Otavio Monteagudo on 9/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

@objc(EndlessGameMode)

class EndlessGameMode: GameMode {
    var healthBar: CCNode!;
    var survivedLabel: CCLabelTTF!;
    
    /* see 'TimedGameMode.swift' for a more detailed explanation on the protocol's attributes */
    
    private(set) var userInterface: CCNode!;
    private let minHealth = 0;
    private let maxHealth = 10;
    
    private var health:Int = 10 {
        didSet {
            let newScale = Float(health) / Float(maxHealth); // assigns new scale and then presents it as an animation
            let scaleAction = CCActionScaleTo.actionWithDuration(0.2, scaleX: newScale, scaleY: 1.0) as! CCAction;
            // if any previous action didn't end, stop actions to prevent glitches
            healthBar.stopAllActions();
            healthBar.runAction(scaleAction);
        }
    }
    
    private var survivalTime: CCTime = 0.0 {
        didSet {
            survivedLabel.string = "Survived: \(Int(survivalTime))";
        }
    }
    
    private let highscoreKey = "EndlessGameMode.Highschore";
    
    private var newHighscore = false;
    
    //subtracts from health if object dropped was a good one
    func gameplay(mainScene:MainScene, droppedFallingObject:FallingObject) {
        if (droppedFallingObject.type == .Good) {
            health = max(health - 1, minHealth);
        }
    }
    
    func gameplay(mainScene:MainScene, caughtFallingObject:FallingObject) {
        switch (caughtFallingObject.type) {
            case .Bad:
                health = max(health - 1, minHealth);
            case .Good:
                health = min(health + 1, maxHealth);
        }
    }
    
    func gameplayStep(mainScene: MainScene, delta: CCTime) -> GameOver {
        survivalTime += delta;
        return (health <= minHealth);
    }
    
    func highscoreMessage() -> String {
        let secondsText = "second".pluralize(survivalTime);
        if (!newHighscore) {
            let oldHighscore = NSUserDefaults.standardUserDefaults().integerForKey(highscoreKey);
            let oldHighscoreText = "second".pluralize(oldHighscore);
            return "You have survived \(Int(survivalTime)) \(secondsText)! Your highscore is \(Int(oldHighscore)) \(oldHighscoreText).";
        } else {
            return "You have reached a new highscore of \(Int(survivalTime)) \(secondsText)!";
        }
    }
    
    func saveHighscore() {
        let oldHigschore = NSUserDefaults.standardUserDefaults().integerForKey(highscoreKey);
        if (Int(survivalTime) > oldHigschore) {
            // if this score is larger than the old highscore, store it
            NSUserDefaults.standardUserDefaults().setInteger(Int(survivalTime), forKey: highscoreKey);
            // this line below forces the device to write the data immediately (it is called automatically from time to time), eliminating the risk of losing data if some crash happens or the user quits the app.
            NSUserDefaults.standardUserDefaults().synchronize();
            newHighscore = true;
        } else {
            newHighscore = false;
        }
    }
    
    init() {
        userInterface = CCBReader.load("EndlessModeUI", owner:self);
    }
    
}
