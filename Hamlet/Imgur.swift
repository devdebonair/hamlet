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
    
    let title: String
    let description: String
    let datetime: Int
    let type: String
    let isAnimated: Bool
    let width: Int
    let height: Int
    let size: Int
    let link: URL?
    let gifv: URL?
    let mp4: URL?
    let isNSFW: Bool
        
    init(map: Mapper) throws {
        title = map.optionalFrom("title") ?? ""
        description = map.optionalFrom("description") ?? ""
        datetime = map.optionalFrom("datetime") ?? 0
        type = map.optionalFrom("type") ?? ""
        isAnimated = map.optionalFrom("animated") ?? false
        width = map.optionalFrom("width") ?? 0
        height = map.optionalFrom("height") ?? 0
        size = map.optionalFrom("size") ?? 0
        link = map.optionalFrom("link")
        gifv = map.optionalFrom("gifv")
        mp4 = map.optionalFrom("mp4")
        isNSFW = map.optionalFrom("nsfw") ?? false
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
        let url = "https://api.imgur.com/3/album/\(id)"
        let headers = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            completion(parseImages(response: response))
        }
    }
    
    static func getGalleryAlbum(id: String, completion: @escaping ([Imgur])->Void) {
        let url = "http://api.imgur.com/3/gallery/album/\(id)"
        let headers = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            completion(parseImages(response: response))
        }
    }
    
    private static func parseImages(response: DataResponse<Any>) -> [Imgur] {
        guard let json = response.result.value as? NSDictionary, let data = json["data"] as? NSDictionary, let images = data["images"] as? NSArray, let imgurImages = Imgur.from(images) else {
            return []
        }
        return imgurImages
    }
}
