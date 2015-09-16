//
//  FallingObj.swift
//  FallingFood
//
//  Created by Otavio Monteagudo on 9/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

private struct ImageNames {
    var good:[String];
    var bad:[String];
    
    init () {
        
        let path = NSBundle.mainBundle().pathForResource("FallingObjectImages", ofType: "plist")!;
        let imageDictionary:Dictionary = NSDictionary(contentsOfFile: path)! as! [String : AnyObject];
        // loaded from FallingObjectImages.plist;
        self.good = imageDictionary["Good"] as! [String];
        println(good.count);
        self.bad = imageDictionary["Bad"] as! [String];
        
    }
}

class FallingObject:CCSprite {
    
    enum FallingObjectType:Int { // assigns 'Int' as the enum type, incrementally mapping each case to an int (good = 0 and bad = 1, in this case).
        case Good;
        case Bad;
    }
    // marks the variable's setter as private, turning it into a readonly property. Value cannot change once it has been assigned.
    private(set) var type: FallingObjectType;
    
    private static let imageNames = ImageNames();
    
    // does it lose on performance?
    init(type: FallingObjectType) {
        self.type = type;
        var imageName:String? = nil;
        if (type == .Good) {
            let randomIndex = Int(arc4random_uniform(UInt32(FallingObject.imageNames.good.count)));
            imageName = FallingObject.imageNames.good[randomIndex];
        } else if (type == .Bad) {
            let randomIndex = Int(arc4random_uniform(UInt32(FallingObject.imageNames.bad.count)));
            imageName = FallingObject.imageNames.bad[randomIndex];
        }
        let spriteFrame = CCSpriteFrame(imageNamed:imageName);
        super.init(texture: spriteFrame.texture, rect: spriteFrame.rect, rotated: false);
        self.anchorPoint = ccp(0,0);
    }
}
