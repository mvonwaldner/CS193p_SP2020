//
//  EmojiMemoryGameView.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import SwiftUI // a package that Apple provides; for any time working with UI stuff

struct EmojiMemoryGameView: View {
	@ObservedObject var viewModel: EmojiMemoryGame // pointer to VM
	
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
	}
}
// container for some variables
// in Swift, can have functions, as well as behaviors

struct CardView: View {
	var card: MemoryGame<String>.Card
	
	var body: some View {
		GeometryReader { geometry in
			self.body(for: geometry.size)
		}
	}
	
	func body(for size: CGSize) -> some View {
		ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
			if card.isFaceUp {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(Color.white)
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(lineWidth: lineWidth)
				Text(card.content)
			} else {
				if !card.isMatched {
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(style: FillStyle())
				} // don't need an else because viewbuilder can handle with empty view
			}
		}
		.font(Font.system(size: fontSize(for: size)))
	}
	
	// MARK: - Drawing Constants
	let cornerRadius: CGFloat = 10.0
	let lineWidth: CGFloat = 3.0
	let fontScaleFactor: CGFloat = 0.75
	
	func fontSize(for size: CGSize) -> CGFloat {
		min(size.width, size.height)*fontScaleFactor
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
