import Foundation

class MainScene: CCNode {
    
    var selectedGameMode: GameModeSelection?;
    
    enum GameModeSelection: Int {
        case Endless;
        case Timed;
    }
    
    weak var pot:Pot!;
    
    private var fallingObjects = [FallingObject]();
    
    
    private let fallingSpeed = 100.0;
    private let spawnFrequency = 0.5; //(in seconds)
    
    private var isDraggingPot = false;
    private var dragTouchOffset = ccp(0,0);
    /* cocos2d methods */
    
    // called as soon as scene is visible and transition finished
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish();
        // spawn objects with defined frequency
        self.userInteractionEnabled = true;
        
        self.schedule("spawnObject", interval: self.spawnFrequency);
    }
    
    override func update(delta: CCTime) {
        // use classic for loop so that we can remove objects while iterating over the array
        for (var i = 0; i < self.fallingObjects.count; i++) {
            let fallingObject = self.fallingObjects[i];
            // let the object fall with a constant speed
            fallingObject.position = ccp(
                fallingObject.position.x,
                fallingObject.position.y - CGFloat(fallingSpeed * delta)
            );
            switch fallingObject.fallState {
                case .Falling:
                    self.performFallingStep(fallingObject)
                case .Missed:
                    self.performMissedStep(fallingObject)
                case .Caught:
                    self.performCaughtStep(fallingObject)
            }
        }
    }
    
    // register touch offset; register that user is currently touching on the screen.
    override func touchBegan(touch: CCTouch, withEvent event: CCTouchEvent) {
        // CGRectContains Point:
        // arg1: a rectangle for a given element that is a part of the main node;
        // arg2: locationInNode returns touch position within the node passed as argument
        if (CGRectContainsPoint(self.pot.boundingBox(), touch.locationInNode(self))) {
            self.isDraggingPot = true;
            // gets distance between pot's anchor point (the center) and the exact touch location (arbitrarily defined) to allow smoother dragging of pot accross the screen. Final pot position is pot current position relative to its own anchor point *plus* touch offset.
            self.dragTouchOffset = ccpSub(pot.anchorPointInPoints, touch.locationInNode(pot));
        }
    }
    
    // actual implementation of pot movement.
    override func touchMoved(touch: CCTouch, withEvent event: CCTouchEvent) {
        if (!self.isDraggingPot) {
            return;
        }
        var newPosition = touch.locationInNode(self);
        // apply touch offset
        newPosition = ccpAdd(newPosition, dragTouchOffset);
        // ensure constant y position
        newPosition = ccp(newPosition.x, pot.positionInPoints.y);
        // apply new position to pot
        self.pot.positionInPoints = newPosition;
    }
    
    // declares 'dragging mode' as over, which will block the pot from spawning in any position the user touches without being dragged.
    override func touchEnded(touch: CCTouch, withEvent event: CCTouchEvent) {
        self.isDraggingPot = false;
    }
    
    // same as above
    override func touchCancelled(touch: CCTouch, withEvent event: CCTouchEvent) {
        self.isDraggingPot = false;
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
    
    func performFallingStep(fallingObject:FallingObject) {
        // CGRectApplyAffineTransform gets the bounding box of the catch container (which is a child of the Pot node) as if it were a child of the MainScene node, which allows comparations of positions of catchContainer's position with other elements which are not present as children of the Pot node.
        let containerWorldBoundingBox = CGRectApplyAffineTransform(
            self.pot.catchContainer.boundingBox(), self.pot.nodeToParentTransform()
        );
        // if all these 3 are true, player has caught the object
        let yPositionInCatchContainer = CGRectGetMinY(fallingObject.boundingBox()) < CGRectGetMaxY(containerWorldBoundingBox);
        let xPositionLargerThanLeftEdge = CGRectGetMinX(fallingObject.boundingBox()) > CGRectGetMinX(containerWorldBoundingBox);
        let xPositionSmallerThanRightEdge = CGRectGetMaxX(fallingObject.boundingBox()) < CGRectGetMaxX(containerWorldBoundingBox);
        if (yPositionInCatchContainer) {
            if (xPositionLargerThanLeftEdge && xPositionSmallerThanRightEdge) {
            // caught the object; adds it as a child of 'pot' to ensure the object won't cross the pot's bounds once it is caught.
            let fallingObjectWorldPosition = fallingObject.parent.convertToWorldSpace(fallingObject.positionInPoints);
            fallingObject.removeFromParent();
            fallingObject.positionInPoints = self.pot.convertToNodeSpace(fallingObjectWorldPosition);
            self.pot.addChild(fallingObject);
            fallingObject.fallState = .Caught;
            fallingObject.zOrder = Pot.DrawingOrder.FallingObject.rawValue;
            } else {
                fallingObject.fallState = .Missed
            }
        }
    }
    
    func performMissedStep(fallingObject:FallingObject) {
        // check if falling object is below the screen boundary
        if (CGRectGetMaxY(fallingObject.boundingBox()) < CGRectGetMinY(boundingBox())) {
            // if object is below screen, remove it
            fallingObject.removeFromParent();
            let fallingObjectIndex = find(fallingObjects, fallingObject)!;
            self.fallingObjects.removeAtIndex(fallingObjectIndex);
            // play sound effect
            self.animationManager.runAnimationsForSequenceNamed("DropSound");
        }
    }
    
    func performCaughtStep(fallingObject: FallingObject) {
        // if the object was caught, remove it as soon as soon as it is entirely contained in the pot
        if (CGRectContainsRect(pot.catchContainer.boundingBox(), fallingObject.boundingBox())) {
            fallingObject.removeFromParent();
            let fallingObjectIndex = find(fallingObjects, fallingObject)!;
            self.fallingObjects.removeAtIndex(fallingObjectIndex);
        }
    }
    
}
