//
//  EmojiMemoryGame.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import SwiftUI // VM knows how the model will be drawn on screen, in this case as an EmojiMemoryGame

class EmojiMemoryGame {
	private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
	// access to model, probably would call this game or memorygame
	
	static func createMemoryGame() -> MemoryGame<String> {
		let emojis: Array<String> = ["👻","🎃","🕷","💀","🍁"]
		return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
			return emojis[pairIndex]
		}
	} // now a function on the type
	
	
	// MARK: - Access to the Model
	
	var cards: Array<MemoryGame<String>.Card> {
		model.cards
	}

	// MARK: - Intent(s)
	
	// functions to let views access the outside world (model)
	
	func choose(card: MemoryGame<String>.Card) {
		model.choose(card: card)
	} // this is the part that could be a SQL database command

} // object-oriented
// portal between views and model

