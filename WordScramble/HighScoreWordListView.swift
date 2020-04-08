//
//  HighScoreWordListView.swift
//  WordScramble
//
//  Created by Emir Küçükosman on 9.04.2020.
//  Copyright © 2020 Emir Küçükosman. All rights reserved.
//

import SwiftUI

struct HighScoreWordListView: View {
    
    @State private var wordList = UserDefaults.standard.value(forKey: "highScoreWordList") as? [String] ?? [String]()
    
    var body: some View {
        VStack {
            List(wordList, id: \.self) {
                Text($0)
            }
        }
    }
}

struct HighScoreWordListView_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreWordListView()
    }
}
