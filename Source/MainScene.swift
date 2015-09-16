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
        // use classic for loop so that we can remove objects while iterating over the array
        for (var i = 0; i < fallingObjects.count; i++) {
            let fallingObject = self.fallingObjects[i];
            // check if falling object is below the screen boundary
            if (CGRectGetMaxY(fallingObject.boundingBox()) < CGRectGetMinY(self.boundingBox())) {
                // if object is below screen, remove it
                fallingObject.removeFromParent();
                fallingObjects.removeAtIndex(i);
                self.animationManager.runAnimationsForSequenceNamed("DropSound");
            } else {
                // else, let the object fall with a constant speed
                fallingObject.position = ccp(
                    fallingObject.position.x,
                    fallingObject.position.y - CGFloat(fallingSpeed * delta)
                )
            }
        }
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
