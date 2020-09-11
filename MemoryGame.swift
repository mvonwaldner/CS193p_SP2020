//
//  MemoryGame.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
	
	private(set) var cards: Array<Card> // don't want anyone messing with cards' properties
	// setting is private, reading is not
	let theme: Theme
	var score: Int = 0
	private var indexOfTheOneAndOnlyFaceUpCard: Int? {
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
	// can't be private - how we play our game
	
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
		var isFaceUp: Bool = false {
			didSet {
				if isFaceUp {
					startUsingBonusTime()
				} else {
					stopUsingBonusTime()
				}
			} // more reliable than trying to look at all places that change isFaceUp's value
		}
		var isMatched: Bool = false {
			didSet {
				stopUsingBonusTime()
			}
		}
		
		var content: CardContent
		var timesChosen: Int = 0
		
		// MARK: - Bonus Time
		
		// this could give matching bonus points
		// if the user matches the card
		// before a certain amount of time passes during which the card is face up
		
		// can be zero which means "no bonus available" for this card
		var bonusTimeLimit: TimeInterval = 6
		
		// how long this card has ever been face up
		private var faceUpTime: TimeInterval {
			if let lastFaceUpDate = self.lastFaceUpDate {
				return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
			} else {
				return pastFaceUpTime
			}
		}
		// the last time this card was turned face up (and is still face up_
		var lastFaceUpDate: Date?
		// the accumulated time this card has been face up in the past
		// (i.e. not including the current time it's been face up if it is currently so)
		var pastFaceUpTime: TimeInterval = 0
		
		// how much time left before the bonus opportunity runs out
		var bonusTimeRemaining: TimeInterval {
			max(0, bonusTimeLimit - faceUpTime)
		}
		// percentage of the bonus time remaining
		var bonusRemaining: Double {
			(bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
		}
		// whether the card was matched during the bonus time period
		var hasEarnedBonus: Bool {
			isMatched && bonusTimeRemaining > 0
		}
		// whether we are currently face up, unmatched and have not yet used up the bonus window
		var isConsumingBonusTime: Bool {
			isFaceUp && !isMatched && bonusTimeRemaining > 0
		}
		
		// called when the card transitions to face up state
		private mutating func startUsingBonusTime() {
			if isConsumingBonusTime, lastFaceUpDate == nil {
				lastFaceUpDate = Date()
			}
		}
		// called when the card goes back face down (or gets matched)
		private mutating func stopUsingBonusTime() {
			pastFaceUpTime = faceUpTime
			self.lastFaceUpDate = nil
		}
		
		
	} // only way you can get a card is through cards array which is already private(set)
}
