//
//  Array+Only.swift
//  Memorize6
//
//  Created by Michael von Waldner on 9/1/20.
//

import Foundation

extension Array {
	var only: Element? {
		count == 1 ? first : nil
	} // if it equals 1, return the first item in the array, otherwise return nil
}
