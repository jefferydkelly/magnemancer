//
//  JDButtonNode.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/13/16.
//  Copyright © 2016 Jeffery Kelly. All rights reserved.
//

import SpriteKit;

class JDButtonNode: SKLabelNode {
    var bgRect:SKShapeNode = SKShapeNode();
    var onClick:()->() = {};
    init(fontName:String, text:String, fontSize:CGFloat, fontColor:SKColor) {
        
        super.init();
        self.fontName = fontName;
        self.text = text;
        self.fontSize = fontSize;
        self.fontColor = fontColor;
        userInteractionEnabled = true;
        bgRect = SKShapeNode(rect: self.frame);
        bgRect.fillColor = SKColor.redColor();
        addChild(bgRect);
    }
    
    convenience init(fontName: String, fontSize:CGFloat, fontColor: SKColor) {
        self.init(fontName: fontName, text: "This is a test", fontSize: fontSize, fontColor: fontColor);
    }
    
    convenience init(fontName: String) {
        self.init(fontName: fontName, text: "This is a test", fontSize: 24, fontColor: SKColor.whiteColor());
    }
    
    convenience override init() {
        self.init(fontName: "MoriaCitadel", text: "This is a test", fontSize: 24, fontColor: SKColor.whiteColor());
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        fontColor = SKColor.redColor();
        bgRect.fillColor = SKColor.whiteColor();
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return;
        }
        
        let touchLocation = touch.locationInNode(self);
        
        if (touchLocation.x < 0 || touchLocation.x > self.frame.width || touchLocation.y < 0 || touchLocation.y > self.frame.height) {
            fontColor = SKColor.whiteColor();
            bgRect.fillColor = SKColor.redColor();
        } else {
            fontColor = SKColor.redColor();
            bgRect.fillColor = SKColor.whiteColor();
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return;
        }
        
        let touchLocation = touch.locationInNode(self);
        
        if (touchLocation.x < 0 || touchLocation.x > self.frame.width || touchLocation.y < 0 || touchLocation.y > self.frame.height) {
            fontColor = SKColor.whiteColor();
            bgRect.fillColor = SKColor.redColor();
        } else {
            fontColor = SKColor.redColor();
            bgRect.fillColor = SKColor.whiteColor();
            onClick();
        }
    }
    
    func resize() {
        bgRect = SKShapeNode(rect: self.frame);
        bgRect.fillColor = SKColor.redColor();
    }
}
