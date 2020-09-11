//
//  EmojiMemoryGameView.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import SwiftUI // a package that Apple provides; for any time working with UI stuff

struct EmojiMemoryGameView: View {
	@ObservedObject var viewModel: EmojiMemoryGame // pointer to VM
	// has to be public
	
    var body: some View {
		VStack {
			Text(viewModel.activeThemeName + " Theme!").font(.largeTitle).bold()
			Divider()
			Text("Score: \(viewModel.score)").font(.headline).bold()
			Grid(viewModel.cards) { card in
				CardView(card: card).aspectRatio(2/3, contentMode: .fit).onTapGesture {
					withAnimation(.linear(duration: 0.75)) {
						self.viewModel.choose(card: card)
					}
				}
				.padding(5)
			}
			.padding()
			.foregroundColor( self.viewModel.activeThemeColor )
			Divider()
			Button("New Game") {
				withAnimation(.easeInOut) {
					self.viewModel.restart()
				}
			}
		}
	} // has to be public
}
// container for some variables
// in Swift, can have functions, as well as behaviors

struct CardView: View {
	var card: MemoryGame<String>.Card // have to be able to access this
	
	var body: some View {
		GeometryReader { geometry in
			self.body(for: geometry.size)
		}
	}
	
	@State private var animatedBonusRemaining: Double = 0 // number of degrees
	
	private func startBonusTimeAnimation() {
		animatedBonusRemaining = card.bonusRemaining // sync up to model
		withAnimation(.linear(duration: card.bonusTimeRemaining)) {
			animatedBonusRemaining = 0
		} // then immediately start animating towards zero
	}
	
	@ViewBuilder
	private func body(for size: CGSize) -> some View {
		if card.isFaceUp || !card.isMatched {
			ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
				Group {
					if card.isConsumingBonusTime {
						Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
							
							.onAppear {
								self.startBonusTimeAnimation()
							}
					} else { // only want pie on screen when animating, and want to use .onAppear
						Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
					}
				}
				.padding(.all, 5).opacity(0.4)
				Text(card.content)
					.font(Font.system(size: fontSize(for: size)))
					.rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
					.animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : Animation.default) //  need this to be on screen when match happens
			}
//			.modifier(Cardify(isFaceUp: card.isFaceUp))
			.cardify(isFaceUp: card.isFaceUp)
			.transition(AnyTransition.scale)
			
		} // else is just blank space
	}
		
	
	
	// MARK: - Drawing Constants

	private let fontScaleFactor: CGFloat = 0.77
	
	func fontSize(for size: CGSize) -> CGFloat {
		min(size.width, size.height)*fontScaleFactor
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let game = EmojiMemoryGame()
		game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
