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
					self.viewModel.choose(card: card)
				}
				.padding(5)
			}
			.padding()
			.foregroundColor( self.viewModel.activeThemeColor )
			Divider()
			Button("New Game") { self.viewModel.restart() }
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
	
	@ViewBuilder
	private func body(for size: CGSize) -> some View {
		if card.isFaceUp || !card.isMatched {
			ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
				Pie(startAngle: Angle.degrees(270), endAngle: Angle.degrees(20), clockwise: true)
					.padding(.all, 5).opacity(0.4)
				Text(card.content)
					.font(Font.system(size: fontSize(for: size)))
			}
//			.modifier(Cardify(isFaceUp: card.isFaceUp))
			.cardify(isFaceUp: card.isFaceUp)
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
