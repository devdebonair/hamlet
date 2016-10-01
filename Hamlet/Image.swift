//
//  Image.swift
//  Hamlet
//
//  Created by Vincent Moore on 9/29/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper

struct Image: Mappable {
    let url: URL
    let height: Int
    let width: Int
    
    init(url: URL, height: Int, width: Int) {
        self.url = url
        self.height = height
        self.width = width
    }
    
    init(map: Mapper) throws {
        try url = map.from("url")
        try height = map.from("height")
        try width = map.from("width")
    }
}

extension Image: Convertible {
    static func fromMap(_ value: Any) throws -> Image {
        guard let image = value as? NSDictionary, let urlString = image["url"] as? String, let url = URL(string: urlString), let height = image["height"] as? Int, let width = image["width"] as? Int else {
            throw MapperError.convertibleError(value: value, type: Image.self)
        }
        return Image(url: url, height: height, width: width)
    }
}
