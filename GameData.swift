//
//  GameData.swift
//  WordScramble
//
//  Created by Emir Küçükosman on 8.04.2020.
//  Copyright © 2020 Emir Küçükosman. All rights reserved.
//

import Foundation

class GameData: ObservableObject {
    
    @Published var actualTime = 30
    @Published var time = 30 {
        didSet {
            UserDefaults.standard.set(self.time, forKey: "timeLimit")
            self.actualTime = self.time
        }
    }
    
    @Published var highScore = 0 {
        didSet {
            UserDefaults.standard.set(self.highScore, forKey: "highScore")
        }
    }
    
    @Published var highestWordLength = 0 {
        didSet {
            UserDefaults.standard.set(self.highestWordLength, forKey: "highestWordLength")
        }
    }
    
    init() {
        if UserDefaults.standard.integer(forKey: "timeLimit") == 0 {
            self.time = 30
        } else {
            self.time = UserDefaults.standard.integer(forKey: "timeLimit")
        }
        self.highestWordLength = UserDefaults.standard.integer(forKey: "highestWordLength")
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
    }
    
}
