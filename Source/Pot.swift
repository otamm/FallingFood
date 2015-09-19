//
//  Pot.swift
//  FallingFood
//
//  Created by Otavio Monteagudo on 9/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class Pot:CCNode {
    weak var catchContainer:CCNode!; // why CCNode and not CCSprite?
    weak var potTop:CCNode!;
    weak var potBottom:CCNode!;
    
    enum DrawingOrder:Int {
        case PotTop;
        case FallingObject;
        case PotBottom;
    }
    
    func didLoadFromCCB() {
        self.potTop.zOrder = DrawingOrder.PotTop.rawValue;
        self.potBottom.zOrder = DrawingOrder.PotBottom.rawValue;
    }
}
