//
//  MemoryGame.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import Foundation

struct MemoryGame<CardContent> {
	var cards: Array<Card>
	
	func choose(card: Card) {
		print("card chosen: \(card)")
	}
	
	init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
		cards = Array<Card>() // cards is now an empty array of cards
		for pairIndex in 0..<numberOfPairsOfCards {
			let content = cardContentFactory(pairIndex)
			cards.append(Card(id: pairIndex*2, content: content))
			cards.append(Card(id: pairIndex*2+1, content: content))
		}
	} // just initializing variables, therefore doesn't have a return value
	
	struct Card: Identifiable {
		let id: Int
		var isFaceUp: Bool = true
		var isMatched: Bool = false
		var content: CardContent
	}
}
