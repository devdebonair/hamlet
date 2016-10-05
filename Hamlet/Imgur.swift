//
//  Imgur.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import Mapper
import Alamofire

struct Imgur: Mappable {
    
    let id: String
    let title: String
    let description: String
    let datetime: Int
    let type: String
    let isAnimated: Bool
    let width: Int
    let height: Int
    let size: Int
    let views: Int
    let bandwidth: Int
    let deletehash: String
    let name: String
    let section: String
    let link: URL?
    let gifv: URL?
    let mp4: URL?
    let mp4_size: Int
    let isLooping: Bool
    let isFavorite: Bool
    let isNSFW: Bool
    let vote: String
    let inGallery: Bool
        
    init(map: Mapper) throws {
        try id = map.from("id") ?? ""
        try title = map.from("title") ?? ""
        try description = map.from("description") ?? ""
        try datetime = map.from("datetime") ?? 0
        try type = map.from("type") ?? ""
        try isAnimated = map.from("animated") ?? false
        try width = map.from("width") ?? 0
        try height = map.from("height") ?? 0
        try size = map.from("size") ?? 0
        try views = map.from("views") ?? 0
        try bandwidth = map.from("bandwidth") ?? 0
        try deletehash = map.from("deletehash") ?? ""
        try name = map.from("name") ?? ""
        try section = map.from("section") ?? ""
        link = map.optionalFrom("link")
        gifv = map.optionalFrom("gifv")
        mp4 = map.optionalFrom("mp4")
        try mp4_size = map.from("mp4_size") ?? 0
        try isLooping = map.from("looping") ?? false
        try isFavorite = map.from("favorite") ?? false
        try isNSFW = map.from("nsfw") ?? false
        try vote = map.from("vote") ?? ""
        try inGallery = map.from("in_gallery") ?? false
    }
    
    static func replaceGIFV(url: URL?) -> URL? {
        guard let url = url else { return nil }
        return url.deletingPathExtension().appendingPathExtension("mp4")
    }
    
    static func isAlbum(url: URL?) -> Bool {
        guard let url = url else { return false }
        let pathComponents = url.pathComponents
        let albumPath = pathComponents[pathComponents.count - 2]
        let validAlbumPaths = ["a", "gallery"]
        return validAlbumPaths.contains(albumPath)
    }
    
    static func isAlbum(url: String) -> Bool {
        return isAlbum(url: URL(string: url))
    }
    
    static func getAlbum(id: String, completion: @escaping ([Imgur])->Void) {
        Alamofire.request("https://api.imgur.com/3/album/\(id)").responseJSON { (response) in
            if let json = response.result.value as? NSDictionary, let data = json["data"] as? NSDictionary, let images = data["images"] as? NSArray {
                let imgurImages = Imgur.from(images)
                if let imgurImages = imgurImages {
                    completion(imgurImages)
                } else {
                    completion([])
                }
            } else {
                completion([])
            }
        }
    }
}
