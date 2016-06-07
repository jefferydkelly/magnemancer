//
//  Player.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/11/16.
//  Copyright © 2016 Jeffery Kelly. All rights reserved.
//

import SpriteKit;

class Player: SKSpriteNode {
    
    var maxCharge: CGFloat = CGFloat(100);
    var chargeLeft:CGFloat = CGFloat(100) {
        didSet {
            if (chargeLeft > maxCharge) {
                chargeLeft = maxCharge;
            } else if (chargeLeft < 0) {
                chargeLeft = 0;
            }
            (scene as! GameScene).chargeRect.xScale = chargeLeft / maxCharge;
        }
    };
    
    var isUsingPush = true;
    let pushForce:CGFloat = 1000;
    let walkForce:CGFloat = 500;
    let powerRange: CGFloat = 1000;
    var lines = [SKShapeNode]();
    var chargeExpendedPerFrame = CGFloat(0.25);
    var playingSound = false;
    
    init() {
        let tex = SKTexture(imageNamed: "magnemancer");
        super.init(texture: tex, color:SKColor.clearColor(), size:tex.size());
        physicsBody = SKPhysicsBody.init(texture: tex, alphaThreshold: 0.1, size: tex.size());
        physicsBody?.categoryBitMask = PhysicsCategory.Player;
        physicsBody?.collisionBitMask = PhysicsCategory.All;
        physicsBody?.allowsRotation = false;
        physicsBody?.mass = 0.5;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func expendCharge(platform:SKSpriteNode) {
        
        if (chargeLeft > 0) {
            
            let lesserMass = platform.physicsBody!.mass < physicsBody!.mass;
         
            let dif = CGVector.init(point: position - platform.position);
            if (dif.length() <= powerRange) {
            
                if (isUsingPush) {
                    if (lesserMass) {
                        platform.physicsBody!.applyForce(dif.normalized() * -pushForce);
                        
                        if (!playingSound) {
                            runAction(SKAction.sequence([SKAction.playSoundFileNamed("magic.wav", waitForCompletion: true), SKAction.runBlock({self.playingSound = false;})]));
                            playingSound = true;
                        }
                    } else {
                        physicsBody?.applyForce(dif.normalized() * pushForce);
                        
                        if (!playingSound) {
                            runAction(SKAction.sequence([SKAction.playSoundFileNamed("push.wav", waitForCompletion: true), SKAction.runBlock({self.playingSound = false;})]));
                            playingSound = true;
                        }
                    }
                    
                    
                    chargeLeft-=chargeExpendedPerFrame;
                } else {
                  
                    if (lesserMass) {
                        platform.physicsBody!.applyForce(dif.normalized() * pushForce);
                        
                    } else {
                        physicsBody?.applyForce(dif.normalized() * -pushForce);
                        
                        if (!playingSound) {
                            runAction(SKAction.sequence([SKAction.playSoundFileNamed("magic.wav", waitForCompletion: true), SKAction.runBlock({self.playingSound = false;})]));
                            playingSound = true;
                        }
                    }
                    
                   
                    chargeLeft-=chargeExpendedPerFrame;
                }
            }
        }
    }
    
    func update() {
        self.removeChildrenInArray(lines);
        lines = [SKShapeNode]();
        scene?.enumerateChildNodesWithName("metal") { node,_ in
            let dif = CGVector.init(point: node.position - self.position);
            let dist = dif.length();
            if (dist <= self.powerRange) {
                let line = self.drawLineTo(dif);
                self.addChild(line);
                self.lines.append(line);
            }
        }
    }
    
    func drawLineTo(v:CGVector) -> SKShapeNode {
        let path: CGMutablePathRef = CGPathCreateMutable();
        let line: SKShapeNode = SKShapeNode(path: path);
        CGPathMoveToPoint(path, nil, 0, 0);
        CGPathAddLineToPoint(path, nil, v.dx, v.dy);
        
        line.path = path;
        line.strokeColor = SKColor.blueColor();
        line.zPosition = 1;
        line.lineWidth = 25;
        return line;
    }
}
