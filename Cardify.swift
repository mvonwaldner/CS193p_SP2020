//
//  Cardify.swift
//  Memorize6
//
//  Created by Michael von Waldner on 9/9/20.
//

import SwiftUI

struct Cardify: ViewModifier {
	var isFaceUp: Bool
	
	
	// argument to content is always the View you're calling body on
	func body(content: Content) -> some View {
		ZStack {
			if isFaceUp {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(Color.white)
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(lineWidth: lineWidth)
				content
			} else {
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(style: FillStyle())
				 // don't need an else because viewbuilder can handle with empty view
			}
		}
	}
	
	private let cornerRadius: CGFloat = 10.0
	private let lineWidth: CGFloat = 3.0
}


extension View {
	func cardify(isFaceUp: Bool) -> some View {
		self.modifier(Cardify(isFaceUp: isFaceUp))
	}
}
