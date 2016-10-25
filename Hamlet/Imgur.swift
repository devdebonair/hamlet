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
    
    enum ImgurThumbnail: String {
        case small = "s"
        case bigSquare = "b"
        case smallThumbnail = "t"
        case medium = "m"
        case large = "l"
        case hughe = "h"
    }
    
    private static let HTTP_HEADERS = [
        "User-Agent": HEADER_USER_AGENT,
        "Authorization": "Client-ID \(IMGUR_CLIENT_ID)"
    ]
    
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
    
    var thumbnailSmall: URL? { return getThumbnail(thumbnail: .smallThumbnail) }
    var thumbnailMedium: URL? { return getThumbnail(thumbnail: .medium) }
    var thumbnailLarge: URL? { return getThumbnail(thumbnail: .large) }
        
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
    
    private func getThumbnail(thumbnail: ImgurThumbnail) -> URL? {
        guard let link = link else { return nil }
        let ext = link.pathExtension
        let pathWithoutExt = link.deletingPathExtension().absoluteString
        return URL(string: "\(pathWithoutExt)\(thumbnail.rawValue).\(ext)")
    }
    
    static func isAlbum(url: String) -> Bool { return isAlbum(url: URL(string: url)) }
    static func isImgurUrl(string: String) -> Bool { return isImgurUrl(url: URL(string: string)) }
    
    static func isImgurUrl(url: URL?) -> Bool {
        guard let url = url, let host = url.host, host.contains("imgur") else { return false }
        return true
    }
    
    static func getID(url: URL?) -> String? {
        guard let url = url, isImgurUrl(url: url) else { return nil }
        return url.deletingPathExtension().lastPathComponent
    }
    
    static func replaceGIFV(url: URL?) -> URL? {
        guard let url = url, isImgurUrl(url: url) else { return nil }
        return url.deletingPathExtension().appendingPathExtension("mp4")
    }
    
    static func getImage(url: URL?, completion: @escaping (Imgur?)->Void) {
        guard let id = getID(url: url) else { return completion(nil) }
        return getImage(id: id, completion: completion)
    }
    
    static func isAlbum(url: URL?) -> Bool {
        guard let url = url, isImgurUrl(url: url) else { return false }
        let pathComponents = url.pathComponents
        let albumPath = pathComponents[pathComponents.count - 2]
        let validAlbumPaths = ["a", "gallery"]
        return validAlbumPaths.contains(albumPath)
    }
    
    static func getAlbum(id: String, completion: @escaping ([Imgur])->Void) {
        let url = "https://api.imgur.com/3/album/\(id)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HTTP_HEADERS).responseJSON { (response) in
            completion(parseImages(response: response))
        }
    }
    
    static func getGalleryAlbum(id: String, completion: @escaping ([Imgur])->Void) {
        let url = "http://api.imgur.com/3/gallery/album/\(id)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HTTP_HEADERS).responseJSON { (response) in
            completion(parseImages(response: response))
        }
    }
    
    static func getImage(id: String, completion: @escaping (Imgur?)->Void) {
        let url = "https://api.imgur.com/3/image/\(id)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HTTP_HEADERS).responseJSON { (response) in
            completion(parseImage(response: response))
        }
    }
    
    private static func parseImage(response: DataResponse<Any>) -> Imgur? {
        guard let json = response.result.value as? NSDictionary, let data = json["data"] as? NSDictionary, let imgurImage = Imgur.from(data) else {
            return nil
        }
        return imgurImage
    }
    
    private static func parseImages(response: DataResponse<Any>) -> [Imgur] {
        guard let json = response.result.value as? NSDictionary, let data = json["data"] as? NSDictionary, let images = data["images"] as? NSArray, let imgurImages = Imgur.from(images) else {
            return []
        }
        return imgurImages
    }
}
