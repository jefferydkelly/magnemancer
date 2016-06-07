//
//  DefaultsManager.swift
//  Magnemancer
//
//  Created by Jeffery Kelly on 4/25/16.
//  Copyright © 2016 Jeffery Kelly. All rights reserved.
//

import Foundation

class DefaultsManager {
    static let sharedDefaultsManager = DefaultsManager();
    
    let LAST_LEVEL_KEY = "lastLevelKey";
    let defaults = NSUserDefaults.standardUserDefaults();
    
    private init() {}
    
    func getGetLastCompletedLevel() ->Int {
        let lastLevel:Int? = defaults.integerForKey(LAST_LEVEL_KEY);
        return lastLevel!;
    }
    
    func setLastCompletedLevel(level:Int) {
        defaults.setInteger(level, forKey: LAST_LEVEL_KEY);
        defaults.synchronize();
        
    }
}