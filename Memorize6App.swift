//
//  Memorize6App.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import SwiftUI

@main
struct Memorize6App: App {
    var body: some Scene {
        WindowGroup {
			let game = EmojiMemoryGame()
			ContentView(viewModel: game)
        }
    }
}
