//
//  NSNumber+CommaFormat.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/13/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation

extension Int {
    var commaFormat: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(integerLiteral: self)) ?? String(self)
    }
}
