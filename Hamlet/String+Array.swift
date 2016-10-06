//
//  String+Array.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/5/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation

extension String {
    func containsOneOf(array: [String]) -> Bool {
        for subString in array {
            if self.contains(subString) {
                return true
            }
        }
        return false
    }
}
