//
//  SettingsView.swift
//  WordScramble
//
//  Created by Emir Küçükosman on 8.04.2020.
//  Copyright © 2020 Emir Küçükosman. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var gameData: GameData
    
    @State private var timeLimit = 30
    
    @State private var alert: Alert!
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Text("High Score: \(gameData.highScore)")
                        Text("Highest Word Length: \(gameData.highestWordLength)")
                        Button("Reset Stats") {
                            self.alertTitle = "Are your sure you want to reset your stats ?"
                            self.alert = Alert(title: Text(self.alertTitle), message: nil, primaryButton: .cancel(), secondaryButton: .destructive(Text("Reset"), action: {
                                self.gameData.highScore = 0
                                self.gameData.highestWordLength = 0
                                UserDefaults.standard.removeObject(forKey: "highScoreWordList")
                            }))
                            self.showingAlert = true
                        }
                    }
                    Section(header: Text("Time Limit")) {
                        Stepper("\(timeLimit) seconds", value: $timeLimit, in: 30...240, step: 10)
                        Button("Save Preference") {
                            self.gameData.time = self.timeLimit
                            self.alertTitle = "Preference has been saved"
                            self.alert = Alert(title: Text(self.alertTitle), message: nil, dismissButton: .default(Text("OK")))
                            self.showingAlert = true
                        }
                    }
                    Section {
                        NavigationLink("High Score Word List", destination: HighScoreWordListView())
                    }
                }
            }
        .navigationBarTitle("Settings")
            .alert(isPresented: $showingAlert) {
                self.alert
            }
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(gameData: GameData())
    }
}
