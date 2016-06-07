//
//  GameViewController.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/11/16.
//  Copyright (c) 2016 Jeffery Kelly. All rights reserved.
//

import UIKit
import SpriteKit

protocol AudioManager {
    func playSong(songNamed:String);
    func stopSong();
}

class GameViewController: UIViewController, AudioManager {

    var bgm:SKAudioNode?;
    override func viewDidLoad() {
        
        super.viewDidLoad();
        let scene = StartMenu();
        scene.audioManager = self;
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func playSong(songNamed: String) {
        if let musicUrl = NSBundle.mainBundle().URLForResource(songNamed, withExtension: ".mp3") {
            bgm?.removeFromParent();
            bgm = SKAudioNode(URL: musicUrl);
            (view as! SKView).scene?.addChild(bgm!);
        }
    }
    
    func stopSong() {
        bgm?.removeFromParent();
    }
}
