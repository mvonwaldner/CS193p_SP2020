//
//  MemoryGame.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
	var cards: Array<Card>
	
	// state in two places, index is also determinable from cards
	var indexOfTheOneAndOnlyFaceUpCard: Int? {
		get { cards.indices.filter { cards[$0].isFaceUp }.only } // can now be a let
//			for index in cards.indices {
//				if cards[index].isFaceUp {
//					faceUpCardIndices.append(index)
//				}
//			}
//			if faceUpCardIndices.count == 1{
//				return faceUpCardIndices.first
//			} else {
//				return nil
//			} // do extension of array to have var that does this
		// want to get index from `cards`
		// need to look at all cards and see which ones are faceup
		set {
			for index in cards.indices {
//				if index == newValue {
					cards[index].isFaceUp = index == newValue
//				} else {
//					cards[index].isFaceUp = false
//				}
			}
		} //  turn other cards face down
		// reacting when someone sets the index of the one and only faceup card
		// set other cards to face down
	}
	
	mutating func choose(card: Card) {
		print("card chosen: \(card)")
		if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
			if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
				if cards[chosenIndex].content == cards[potentialMatchIndex].content {
					cards[chosenIndex].isMatched = true
					cards[potentialMatchIndex].isMatched = true
				}
//				indexOfTheOneAndOnlyFaceUpCard = nil // two cards faceup, so this needs to be nil now because there are two
			} else {
//				for index in cards.indices {
//					cards[index].isFaceUp = false
//				}
				indexOfTheOneAndOnlyFaceUpCard = chosenIndex // it will be the only faceup card. Just turned all of others face down, and will turn the other one face up in code right outside of this conditional
			}
			self.cards[chosenIndex].isFaceUp = true // turn our card faceup
//			self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp // copies card out of array
		} // choose does nothing if we can't find card within our cards
	} // all functions that modify self have to be marked as mutating
	
	init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
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
	}
}
