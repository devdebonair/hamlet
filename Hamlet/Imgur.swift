//
//  Imgur.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation

struct Imgur {
    static func replaceGIFV(url: URL?) -> URL? {
        guard let url = url else {
            return nil
        }
        return url.deletingPathExtension().appendingPathExtension("mp4")
    }
}
