//
//  StartMenu.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/13/16.
//  Copyright © 2016 Jeffery Kelly. All rights reserved.
//

import SpriteKit;
import AVKit;

class StartMenu: SKScene {
    let title = SKLabelNode(fontNamed: "MoriaCitadel");
    let startButton = JDButtonNode(fontName: "MoriaCitadel", text: "Start Game", fontSize: 48, fontColor: SKColor.whiteColor());
    let continueButton = JDButtonNode(fontName: "MoriaCitadel", text: "Continue", fontSize: 48, fontColor: SKColor.whiteColor());
    var audioManager:AudioManager!;
    
    override func didMoveToView(view: SKView) {
        size = CGSizeMake(1024, 768);
        backgroundColor = SKColor(red: 45 / 255, green: 15 / 255, blue: 90 / 255, alpha: 1);
        title.text = "Magnemancer";
        title.fontSize = 48;
        title.position = CGPoint(x: size.width / 2, y: size.height * 3 / 4);
        title.fontColor = SKColor.whiteColor();
        addChild(title);
        
        startButton.position = CGPoint(x:size.width / 2, y:size.height / 2);
        startButton.onClick = {
            if let scene = GameScene.loadLevel(1) {
                self.audioManager.stopSong();
                scene.audioManager = self.audioManager;
                scene.size = CGSize(width: 2048, height: 1536);
                
                self.view?.presentScene(scene);
               
            }
        }
        
        addChild(startButton);
        
        let lastLevel = DefaultsManager.sharedDefaultsManager.getGetLastCompletedLevel();
        if (lastLevel > 0 && GameScene.loadLevel(lastLevel) != nil) {
            continueButton.position = CGPoint(x:size.width / 2, y:size.height / 2 - 75);
            continueButton.onClick = {
                
                if let scene = GameScene.loadLevel(lastLevel) {
                    self.audioManager.stopSong();
                    scene.audioManager = self.audioManager;
                    scene.size = CGSize(width: 2048, height: 1536);
                    
                    self.view?.presentScene(scene);
                }
            }
            
            addChild(continueButton);
        }
        audioManager.playSong("Wonder_And_Magic");
        
    }
}
