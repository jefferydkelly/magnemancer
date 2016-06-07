//
//  GameScene.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/11/16.
//  Copyright (c) 2016 Jeffery Kelly. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None: UInt32 = 0;
    static let Player: UInt32 = 0b1; //1
    static let Block: UInt32 = 0b10; //2
    static let Metal: UInt32 = 0b100; //4
    static let EndFlag: UInt32 = 0b1000; //8
    static let Spike: UInt32 = 0b10000; //16
    static let PlayableRect: UInt32 = 0b100000; //32
    static let Potion:UInt32 = 0b1000000; // 64
    static let All: UInt32 = UInt32.max;
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    var playableRect:CGRect = CGRectZero;
    var player: Player!;
    var lastUpdateTime = 0;
    var touched = false;
    var touchLocation:CGPoint = CGPoint.zero;
    var touchedNode: SKSpriteNode!;
    var touchingAMetalNode: Bool = false;
    var currentLevel = 0;
    
    var restartAction: SKAction = SKAction.waitForDuration(1);;
    var nextLevelAction: SKAction = SKAction.waitForDuration(1);
    
    let cameraScale:CGFloat = 0.5;
    let pushTexture = SKTexture(imageNamed: "push");
    let pullTexture = SKTexture(imageNamed: "pull");
    var chargeRect:SKShapeNode = SKShapeNode(rectOfSize: CGSize(width: 300, height: 50));
    let swapPowerButton = JDSpriteButtonNode(imageNamed: "push");
    let chargeRestoredByPotion = CGFloat(25);
    
    var levelCompleted = false;
    var audioManager:AudioManager!;
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // Calculate playable margin for landscape
        //size = CGSize(width: 2048, height:1536);
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5;
        let maxAspectRatioHeight = size.width / maxAspectRatio;
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2;
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width, height: size.height-playableMargin*2);
        physicsWorld.gravity = CGVectorMake(0, -9.8);
        physicsWorld.contactDelegate = self;
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect);
        physicsBody?.categoryBitMask = PhysicsCategory.PlayableRect;
        player = Player();
        let spawn = childNodeWithName("player_spawn");
        player.position = (spawn?.position)!;
        addChild(player);
        camera = childNodeWithName("camera") as? SKCameraNode;
        camera?.setScale(cameraScale);
    
        restartAction = SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.runBlock(restartLevel)]);
        nextLevelAction = SKAction.sequence([SKAction.playSoundFileNamed("victory.mp3", waitForCompletion: false), SKAction.waitForDuration(1.0), SKAction.runBlock(nextLevel)]);
        
        swapPowerButton.xScale = 2;
        swapPowerButton.yScale = 2;
        swapPowerButton.zPosition = 2;
        swapPowerButton.position = CGPoint(x: size.width * cameraScale - swapPowerButton.size.width, y: 0);
        swapPowerButton.onClick = {
            self.player.isUsingPush = !self.player.isUsingPush;
            
            if (self.player.isUsingPush) {
                self.swapPowerButton.texture = self.pushTexture;
            } else {
                self.swapPowerButton.texture = self.pullTexture;
            }
        };
        camera?.addChild(swapPowerButton);
    
        chargeRect.position = CGPoint(x: -size.width / 2 * cameraScale, y: (size.height * cameraScale) - 50);
        chargeRect.zPosition = 2;
        chargeRect.fillColor = SKColor.redColor();
        camera?.addChild(chargeRect);
        audioManager.playSong("Magical_Night");
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return;
        }
        
        let touchLocation = touch.locationInNode(self);
        let touchedNode = nodeAtPoint(touchLocation);
        
        if (touchedNode.physicsBody?.categoryBitMask == PhysicsCategory.Metal) {
            touchingAMetalNode = true;
            self.touchedNode = touchedNode as! SKSpriteNode;
            self.touchedNode.color = SKColor.blueColor();
        } else {
            touched = true;
            self.touchLocation = touchLocation;
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return;
        }
        touchLocation = touch.locationInNode(self);
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touched = false;
        touchingAMetalNode = false;
        
        if (touchedNode != nil) {
            touchedNode.color = SKColor.clearColor();
        }
        touchedNode = nil;
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        player.update();
        if (touched) {
            let dif = CGVector.init(point: (touchLocation - player.position).normalized());
            player.physicsBody?.applyForce(dif * player.walkForce);
        } else if (touchingAMetalNode) {
            player.expendCharge(touchedNode);
        }
        
        camera?.position = player.position;
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask;
        
        if (collision == PhysicsCategory.Player | PhysicsCategory.Spike) {
            print("Dead");
            runAction(restartAction);
        } else if (collision == PhysicsCategory.Player | PhysicsCategory.EndFlag) {
            if (!levelCompleted) {
                runAction(nextLevelAction);
                levelCompleted = true;
            }
        } else if (collision == PhysicsCategory.Player | PhysicsCategory.Potion) {
            player.chargeLeft += chargeRestoredByPotion;
            
            if (contact.bodyA.node == player) {
                contact.bodyB.node?.removeFromParent();
            } else {
                contact.bodyA.node?.removeFromParent();
            }
        }
    }
    
    func nextLevel() {
        audioManager.stopSong();
        if GameScene.loadLevel(currentLevel + 1) != nil {
            let nextScene = LevelVictoryScene(levelNum: currentLevel, size:size);
            nextScene.audioManager = audioManager;
            view?.presentScene(nextScene);
        } else {
            let nextScene = StartMenu();
            nextScene.audioManager = audioManager;
            view?.presentScene(nextScene);
        }
    }
    
    func restartLevel() {
        audioManager.stopSong();
        if let scene = GameScene.loadLevel(currentLevel) {
            print("Reloading");
            scene.audioManager = self.audioManager;
            view?.presentScene(scene)
        }
    }
    class func loadLevel(level:Int)->GameScene? {
        if let scene = GameScene(fileNamed: "Level\(level)") {
            scene.currentLevel = level;
            scene.scaleMode = .AspectFill;
            return scene;
        }
        
        return nil;
    }
}
