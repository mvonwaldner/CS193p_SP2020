//
//  MemoryGame.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
	
	var cards: Array<Card>
	let theme: Theme
	var score: Int = 0
	var indexOfTheOneAndOnlyFaceUpCard: Int? {
		get { cards.indices.filter { cards[$0].isFaceUp }.only }
		set {
			for index in cards.indices {
					cards[index].isFaceUp = index == newValue
			}
		} //  turn other cards face down
	}
	
	mutating func choose(card: Card) {
			
		if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
		// scenario where chosenIndex is not face up, and it is not matched (clicking on a face down card, either first pick or second pick)

			if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
			// scenario where there was already a face up card (the indexOFTheOneAndOnlyFaceUpCard) (second pick)

				
				if cards[chosenIndex].content == cards[potentialMatchIndex].content {
				// scenario of a match
					
					cards[chosenIndex].timesChosen += 1
					cards[chosenIndex].isMatched = true
					cards[potentialMatchIndex].isMatched = true
					self.score += 2
					
				} else {
				// scenario of a mismatch
					
					cards[chosenIndex].timesChosen += 1
					if cards[chosenIndex].timesChosen > 1, cards[potentialMatchIndex].timesChosen > 1 {
						self.score -= 2
					} else if cards[chosenIndex].timesChosen > 1 {
						self.score -= 1
					}
				}
				print("ending card data for the 2nd pick card: \(cards[chosenIndex])")
			
			
			} else {
			// scenario where there was not already a face up card (first pick)
				
				indexOfTheOneAndOnlyFaceUpCard = chosenIndex // it will be the only faceup card. Just turned all of others face down, and will turn the other one face up in code right outside of this conditional
				self.cards[chosenIndex].timesChosen += 1
				print("ending card data for the 1st pick card: \(self.cards[chosenIndex])")
			}
			self.cards[chosenIndex].isFaceUp = true // turn our card faceup
			
		} // choose(card:) does nothing if we can't find card within our cards, and also this would be a case of clicking on a face up card
		
	} // all functions that modify self have to be marked as mutating
	
	init(theme: Theme, numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
		self.theme = theme
		cards = Array<Card>() // cards is now an empty array of cards
		for pairIndex in 0..<numberOfPairsOfCards {
			let content = cardContentFactory(pairIndex)
			cards.append(Card(id: pairIndex*2, content: content))
			cards.append(Card(id: pairIndex*2+1, content: content))
		}
		cards.shuffle()
	} // just initializing variables, therefore doesn't have a return value
	
	struct Card: Identifiable {
		let id: Int
		var isFaceUp: Bool = false
		var isMatched: Bool = false
		var content: CardContent
		var timesChosen: Int = 0
	}
}
