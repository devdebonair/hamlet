//
//  Gfycat.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper
import Alamofire

struct Gfycat: Mappable {
    let id: String
    let name: String
    let number: String
    let username: String
    let views: Int
    let title: String
    let tags: [String]
    private let _width: String
    private let _height: String
    let urlMP4: URL?
    let urlGIF: URL?
    
    var width: Int? {
        return Int(_width)
    }
    
    var height: Int? {
        return Int(_height)
    }
    
    init(map: Mapper) throws {
        try id = map.from("gfyId")
        try name = map.from("gfyName")
        try number = map.from("gfyNumber")
        try username = map.from("userName")
        try views = map.from("views")
        try title = map.from("title")
        try tags = map.from("tags")
        try _width = map.from("width")
        try _height = map.from("height")
        urlMP4 = map.optionalFrom("mp4Url")
        urlGIF = map.optionalFrom("gifUrl")
    }
}

extension Gfycat {
    static func fetch(name: String, completion: @escaping (Gfycat?)->Void) {
        Alamofire.request("https://gfycat.com/cajax/get/\(name)").responseJSON { (response) in
            guard let json = response.result.value as? NSDictionary, let gfyData = json["gfyItem"] as? NSDictionary else {
                return completion(nil)
            }
            let gfycat = Gfycat.from(gfyData)
            completion(gfycat)
        }
    }
    
    static func fetch(url: URL?, completion: @escaping (Gfycat?)->Void) {
        guard let url = url else {
            return completion(nil)
        }
        let name = url.lastPathComponent
        fetch(name: name, completion: completion)
    }
}
