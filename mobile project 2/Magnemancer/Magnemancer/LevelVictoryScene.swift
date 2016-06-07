//
//  LevelVictoryScene.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/25/16.
//  Copyright © 2016 Jeffery Kelly. All rights reserved.
//

import SpriteKit;

class LevelVictoryScene : SKScene {
    
    var congratsText = SKLabelNode(fontNamed: "MoriaCitadel");
    var nextLevelButton = JDButtonNode(fontName: "MoriaCitadel", fontSize: 100, fontColor: SKColor.whiteColor());
    var audioManager:AudioManager!;
    init(levelNum:Int, size:CGSize) {
        super.init(size: size);
        backgroundColor = SKColor(red: 45 / 255, green: 15 / 255, blue: 90 / 255, alpha: 1);
        congratsText.text = "Congratulations!  You've completed Level \(levelNum).";
        congratsText.horizontalAlignmentMode = .Center;
        congratsText.fontSize = 60;
        congratsText.position = CGPointMake(size.width / 2, size.height * 3 / 4);
        addChild(congratsText);
        
        nextLevelButton.text = "Next Level";
        nextLevelButton.horizontalAlignmentMode = .Center;
        nextLevelButton.position = CGPointMake(size.width / 2, size.height / 2);
        nextLevelButton.onClick = {
            if let scene = GameScene.loadLevel(levelNum + 1) {
                scene.audioManager = self.audioManager;
                scene.currentLevel = levelNum + 1;
                self.view?.presentScene(scene);
            }
        }
        nextLevelButton.resize();
        addChild(nextLevelButton);
        DefaultsManager.sharedDefaultsManager.setLastCompletedLevel(levelNum + 1);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}