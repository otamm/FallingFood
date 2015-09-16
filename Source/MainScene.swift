import Foundation

class MainScene: CCNode {
    
    private var fallingObjects = [FallingObject]();
    
    
    private let fallingSpeed = 100.0;
    private let spawnFrequency = 0.5; //(in seconds)
    
    /* cocos2d methods */
    
    // called as soon as scene is visible and transition finished
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish();
        // spawn objects with defined frequency
        self.schedule("spawnObject", interval: self.spawnFrequency);
    }
    
    override func update(delta: CCTime) {
        
    }
    
    
    /* custom methods */
    func spawnObject() {
        let randomNumber = Int(arc4random_uniform(UInt32(2)));
        let fallingObjectType = FallingObject.FallingObjectType(rawValue: randomNumber)!;
        let fallingObject = FallingObject(type:fallingObjectType);
        // add all spawning objects to an array
        self.fallingObjects.append(fallingObject);
        //spawn all objects at top of screen and at a random x position within scene bounds;
        let xSpawnRange = Int(self.contentSizeInPoints.width - CGRectGetMaxX(fallingObject.boundingBox()));
        let spawnPosition = ccp(CGFloat(Int(arc4random_uniform(UInt32(xSpawnRange)))), self.contentSizeInPoints.height);
        fallingObject.position = spawnPosition;
        self.addChild(fallingObject);
    }
    
}
