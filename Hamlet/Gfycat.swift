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
    let id: String?
    let name: String?
    let number: String?
    let username: String?
    let views: Int?
    let title: String?
    let tags: [String]?
    private let _width: String?
    private let _height: String?
    let urlMP4: URL?
    let urlGIF: URL?
    
    var width: Int? {
        guard let _width = _width else {
            return 0
        }
        return Int(_width)
    }
    
    var height: Int? {
        guard let _height = _height else {
            return 0
        }
        return Int(_height)
    }
    
    init(map: Mapper) throws {
        id = map.optionalFrom("gfyId")
        name = map.optionalFrom("gfyName")
        number = map.optionalFrom("gfyNumber")
        username = map.optionalFrom("userName")
        views = map.optionalFrom("views")
        title = map.optionalFrom("title")
        tags = map.optionalFrom("tags")
        _width = map.optionalFrom("width")
        _height = map.optionalFrom("height")
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
