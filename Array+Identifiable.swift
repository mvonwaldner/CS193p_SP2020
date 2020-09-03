//
//  Array+Identifiable.swift
//  Memorize6
//
//  Created by Michael von Waldner on 9/1/20.
//

import Foundation

extension Array where Element: Identifiable {
	func firstIndex(matching: Element) -> Int? {
		for index in 0..<self.count {
			if self[index].id == matching.id {
				return index // here the optional is returning the Int associated value when it is in the .some case
			}
		}
		return nil // optional lets us return nil
	}
}
