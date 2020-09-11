//
//  Cardify.swift
//  Memorize6
//
//  Created by Michael von Waldner on 9/9/20.
//

import SwiftUI

struct Cardify: AnimatableModifier {
	var rotation: Double
	
	init(isFaceUp: Bool) {
		rotation = isFaceUp ? 0 : 180
	}
	
	var isFaceUp: Bool {
		rotation < 90
	} // linked rotation and isFaceUp/Down
	
	var animatableData: Double {
		get { return rotation }
		set { rotation = newValue }
	}
	
	// argument to content is always the View you're calling body on
	func body(content: Content) -> some View {
		ZStack {
			Group {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(Color.white)
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(lineWidth: lineWidth)
				content
			}
				.opacity(isFaceUp ? 1 : 0)
			RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(style: FillStyle())
				.opacity(isFaceUp ? 0 : 1)
				 // don't need an else because viewbuilder can handle with empty view
		}
		.rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0)) // rotating ZStack
		// want to be able to control rotation of ZStack
	}
	
	private let cornerRadius: CGFloat = 10.0
	private let lineWidth: CGFloat = 3.0
}


extension View {
	func cardify(isFaceUp: Bool) -> some View {
		self.modifier(Cardify(isFaceUp: isFaceUp))
	}
}
