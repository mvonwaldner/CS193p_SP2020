//
//  EmojiMemoryGame.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import SwiftUI // VM knows how the model will be drawn on screen, in this case as an EmojiMemoryGame

class EmojiMemoryGame: ObservableObject {
	@Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
	// access to model, probably would call this game or memorygame
	
	
	static func createMemoryGame() -> MemoryGame<String> {
		let activeTheme = createdThemes[Int.random(in: 0..<createdThemes.count)]
		let emojis: Array<String> = activeTheme.emojis
		return MemoryGame<String>(theme: activeTheme, numberOfPairsOfCards: activeTheme.numberOfPairsOfCards!) { pairIndex in
			return emojis[pairIndex]
		}
	} // now a function on the type

	// MARK: - Access to the Model
	
	var cards: Array<MemoryGame<String>.Card> {
		model.cards
	}
	
	var score: Int {
		model.score
	}
	
	var activeThemeName: String {
		model.theme.name
	}
	
	var activeThemeColor: Color {
		model.theme.color!
	}
	
	// MARK: - Intent(s)
	
	// functions to let views access the outside world (model)
	func choose(card: MemoryGame<String>.Card) {
		model.choose(card: card)
	} // this is the part that could be a SQL database command

	// restart function for New Game button
	func restart() -> Void {
		model = EmojiMemoryGame.createMemoryGame()
	}
	
	
} // object-oriented
// portal between views and model

// MARK: - Theme Data

struct Theme {
	let name: String
	let emojis: [String]
	let numberOfPairsOfCards: Int?
	let color: Color?
	init(name: String, emojis: [String], numberOfPairsOfCards: Int?, color: Color?) {
		self.name = name
		self.emojis = emojis
		switch numberOfPairsOfCards {
			case .none: self.numberOfPairsOfCards = Int.random(in: 2...emojis.count)
			case .some(let number) where number > 0: self.numberOfPairsOfCards = number
			default: self.numberOfPairsOfCards = Int.random(in: 2...emojis.count)
		}
		switch color {
			case .none: self.color = .black
			case .some(let chosenColor): self.color = chosenColor
		}
	}
}
var createdThemes: [Theme] = [
	Theme(name: "Halloween", emojis: ["👻","🎃","🕷","💀","🍁"], numberOfPairsOfCards: nil, color: .orange),
	Theme(name: "Christmas", emojis: ["🎄","🎅","🤶","🍪"], numberOfPairsOfCards: 4, color: .red),
	Theme(name: "Summer", emojis: ["🍉","☀️","🏄‍♂️","🏖"], numberOfPairsOfCards: 4, color: .yellow),
	Theme(name: "Sports", emojis: ["🏈","⚾️","🎾","⚽️","🏀"], numberOfPairsOfCards: nil, color: .blue),
	Theme(name: "Travel", emojis: ["🛤","🏞","🧳","✈️","🚅"], numberOfPairsOfCards: 5, color: .green),
	Theme(name: "Spring", emojis: ["💐","🐰","✝️","🌳"], numberOfPairsOfCards: nil, color: .pink),
]
								

