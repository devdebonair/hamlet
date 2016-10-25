//
//  String+HTMLDecode.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/24/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation

extension String {
    var htmlDecodedString: String {
        let tags = [
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&nbsp;": "\u{00a0}",
            "&diams;": "♦"]
        var retval = self
        for (key, value) in tags { retval = retval.replacingOccurrences(of: key, with: value) }
        return retval
    }
}
