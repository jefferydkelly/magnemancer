//
//  JDSpriteButtonNode.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/14/16.
//  Copyright © 2016 Jeffery Kelly. All rights reserved.
//

import SpriteKit;

class JDSpriteButtonNode: SKSpriteNode {
    var onClick:()->() = {print("You clicked me")};
    
    init(imageNamed:String) {
        let tex = SKTexture(imageNamed: imageNamed);
        super.init(texture: tex, color:SKColor.clearColor(), size:tex.size());
        userInteractionEnabled = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return;
        }
        
         onClick();
        let touchLocation = touch.locationInNode(self);
        
        if (touchLocation.x >= 0 && touchLocation.x <= self.size.width && touchLocation.y >= 0 && touchLocation.y <= self.size.height) {
           
        }
    }

}
