//
//  ContentView.swift
//  WordScramble
//
//  Created by Emir Küçükosman on 8.04.2020.
//  Copyright © 2020 Emir Küçükosman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var words = [String]()
    @State private var rootWord = ""
    @State private var lastWordLastChar: Character!
    
    @State private var time = 30
    @State private var score = 0
    
    @ObservedObject var gameData = GameData()
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var showingSettings = false
    
    @State private var timeColor = Color.primary
    @State private var scoreColor = Color.primary
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter a word", text: $rootWord, onCommit: addNewWord)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List(words, id: \.self) {
                    Text($0)
                }
            }
        .navigationBarTitle("WordScramble")
        .navigationBarItems(leading: VStack(alignment: .leading) {
            Text("Time: \(gameData.actualTime)")
                .foregroundColor(timeColor)
            Text("Score: \(score)")
                .foregroundColor(scoreColor)
            }, trailing: Button(action: {
                self.showingSettings = true
            }){
                Image(systemName: "gear")
                    .imageScale(.large)
        })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(gameData: self.gameData)
            }
        }
    }
    
    func addNewWord() {
        rootWord = rootWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard rootWord.count >= 3  && rootWord.count < 16 else {
            alertTitle = "Your word must be at least 3, maximum 16 characters long"
            showingAlert = true
            return
        }
        if words.count == 0 {
            countdown()
            words.insert(rootWord, at: 0)
            lastWordLastChar = rootWord.last!
            score += rootWord.count
            if score > gameData.highScore {
                scoreColor = .green
            }
            if rootWord.count > gameData.highestWordLength {
                gameData.highestWordLength = rootWord.count
            }
            rootWord = ""
        } else {
            if lastWordLastChar == rootWord.first! {
                words.insert(rootWord, at: 0)
                lastWordLastChar = rootWord.last!
                score += rootWord.count
                if score > gameData.highScore {
                    scoreColor = .green
                }
                if rootWord.count > gameData.highestWordLength {
                    gameData.highestWordLength = rootWord.count
                }
                rootWord = ""
            } else {
                alertTitle = "Your new word must start with last word's first letter"
                showingAlert = true
            }
        }
    }
    
    func countdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.gameData.actualTime -= 1
            if self.gameData.actualTime == 0 {
                self.reset()
                timer.invalidate()
            }
            if self.gameData.actualTime < 11 {
                self.timeColor = .red
            }
        }
    }
    
    func reset() {
        if score > gameData.highScore {
            gameData.highScore = score
            UserDefaults.standard.set(words, forKey: "highScoreWordList")
            alertTitle = "New High Score !"
        } else { alertTitle = "Time Finished" }
        alertMessage = "Score: \(score)\nHigh Score: \(gameData.highScore)"
        words.removeAll(keepingCapacity: false)
        rootWord = ""
        gameData.actualTime = gameData.time
        time = gameData.actualTime
        scoreColor = .primary
        timeColor = .primary
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
