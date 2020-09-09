//
//  Pie.swift
//  Memorize6
//
//  Created by Michael von Waldner on 9/8/20.
//

import SwiftUI

struct Pie: Shape {
	
	var startAngle: Angle
	var endAngle: Angle
	var clockwise: Bool = false
	
	func path(in rect: CGRect) -> Path {
		
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2
		let start = CGPoint(
			x: center.x + radius * cos(CGFloat(startAngle.radians)),
			y: center.y + radius * sin(CGFloat(startAngle.radians))
		)
		
		
		var p = Path()
		// call function in path that move lines, etc
		p.move(to: center)
		p.addLine(to: start)
		p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
		p.addLine(to: center)
		return p
		
	}
	
}
