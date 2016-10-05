//
//  Image.swift
//  Hamlet
//
//  Created by Vincent Moore on 9/29/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper

struct Media: Mappable {
    private let _url: URL
    let height: Int
    let width: Int
    
    var url: URL {
        let urlString = _url.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)?.replacingOccurrences(of: "amp;", with: "")
        return URL(string: urlString!)!
    }
    
    init(url: URL, height: Int, width: Int) {
        self._url = url
        self.height = height
        self.width = width
    }
    
    init(map: Mapper) throws {
        try _url = map.from("url")
        try height = map.from("height")
        try width = map.from("width")
    }
}

extension Media: Convertible {
    static func fromMap(_ value: Any) throws -> Media {
        guard let image = value as? NSDictionary, let urlString = image["url"] as? String, let url = URL(string: urlString), let height = image["height"] as? Int, let width = image["width"] as? Int else {
            throw MapperError.convertibleError(value: value, type: Media.self)
        }
        return Media(url: url, height: height, width: width)
    }
}
