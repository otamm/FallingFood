//
//  StartScene.swift
//  FallingFood
//
//  Created by Otavio Monteagudo on 9/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class StartScene:CCNode {
    
    weak var scrollView:CCScrollView!;
    
    weak var playButton:CCButton!;
    
    /* custom variables */
    
    // endless at first, as it is the first game mode option presented.
    var selectedGameMode:MainScene.GameModeSelection = .Endless;
    
    /* cocos2d methods */
    
    func didLoadFromCCB() {
        // adds this StartScene class as the owner of the ScrollView delegate methods (see pg. 166 of 'Learn 2D iPhone Game Development' book)
        scrollView.delegate = self;
    }
    /* animation callbacks/button methods */
    func play() {
        self.scrollView.userInteractionEnabled = false;
        animationManager.runAnimationsForSequenceNamed("StartGameplay");
    }
    
    /* animation callback defined in StartScene */
    func transitionAnimationComplete() {
        let scene = CCBReader.loadAsScene("MainScene");
        var gameplay = scene.children[0] as! MainScene;
        gameplay.selectedGameMode = self.selectedGameMode;
        let transition = CCTransition(crossFadeWithDuration: 0.7);
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition);
    }
}

extension StartScene:CCScrollViewDelegate {
    
    // called once
    func scrollViewWillBeginDragging(scrollView: CCScrollView!) {
        // makes playButton non-interectable while player drags scroll view options
        self.playButton.enabled = false;
    }
    
    // called once player stops dragging along the scroll view
    func scrollViewDidEndDecelerating(scrollView: CCScrollView) {
        self.playButton.enabled = true;
        self.selectedGameMode = MainScene.GameModeSelection(rawValue: Int(scrollView.horizontalPage))!;
    }
}
