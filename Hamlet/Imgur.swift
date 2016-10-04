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
    
    static func isAlbum(url: URL?) -> Bool {
        guard let url = url else { return false }
        let pathComponents = url.pathComponents
        let albumPath = pathComponents[pathComponents.count - 2]
        return albumPath == "a"
    }
    
    static func isAlbum(url: String) -> Bool {
        return isAlbum(url: URL(string: url))
    }
}
