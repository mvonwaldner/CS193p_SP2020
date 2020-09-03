//
//  ContentView.swift
//  Memorize6
//
//  Created by Michael von Waldner on 8/31/20.
//

import SwiftUI // a package that Apple provides; for any time working with UI stuff

struct ContentView: View {
	var viewModel: EmojiMemoryGame // pointer to VM
	
    var body: some View {
		HStack {
			ForEach(viewModel.cards) { card in
				CardView(card: card).onTapGesture {
					viewModel.choose(card: card)
				}
				.aspectRatio(2/3, contentMode: .fit)
			}
		}
		.padding()
		.foregroundColor(Color.orange)
		.font(viewModel.cards.count > 8 ? Font.body : Font.largeTitle)
		
    }
}
// container for some variables
// in Swift, can have functions, as well as behaviors

struct CardView: View {
	var card: MemoryGame<String>.Card
	
	var body: some View {
		ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
			if card.isFaceUp {
				RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(Color.white)
				RoundedRectangle(cornerRadius: 10.0, style: .continuous).stroke(lineWidth: 1.0)
				Text(card.content)
			} else {
				RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(style: FillStyle())
			}
		}
	}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
