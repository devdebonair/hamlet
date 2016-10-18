//
//  Image.swift
//  Hamlet
//
//  Created by Vincent Moore on 9/29/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//


// !!!! NEED TO GET RID OF THE HARD CODED GFYCAT IMPLEMENTATION !!!!!

import Mapper

let VALID_VIDEO_FORMATS = [".gifv", ".mov", ".mp4"]
let VALID_PHOTO_FORMATS = [".gif", ".jpg", ".jpeg", ".png"]

struct Media: Mappable {
    
    enum MediaType: String {
        case photo = "photo"
        case video = "video"
    }
    
    private let _url: URL?
    let height: Int
    let width: Int
    let type: MediaType
    let poster: URL?
    
    var url: URL? {
        let urlString = _url?.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)?.replacingOccurrences(of: "amp;", with: "")
        if let urlString = urlString {
            return URL(string: urlString)
        }
        return nil
    }
    
    init(url: URL?, height: Int, width: Int, type: MediaType? = nil, poster: URL? = nil) {
        self._url = url
        self.height = height
        self.width = width
        let tempType = Media.getMediaType(url: _url)
        self.type = type ?? tempType ?? .photo
        self.poster = poster
    }
    
    init(map: Mapper) throws {
        _url = map.optionalFrom("url")
        try height = map.from("height")
        try width = map.from("width")
        let suggestedMediaType = Media.getMediaType(url: _url)
        type = map.optionalFrom("type") ?? suggestedMediaType ?? .photo
        poster = nil
    }
    
}

extension Media: Convertible {
    static func getMediaType(url: URL?) -> MediaType? {
        guard let url = url else { return nil }
        if url.absoluteString.containsOneOf(array: VALID_VIDEO_FORMATS) || url.absoluteString.contains("gfycat") { return .video }
        if url.absoluteString.containsOneOf(array: VALID_PHOTO_FORMATS) { return .photo }
        return nil
    }
    
    static func fromMap(_ value: Any) throws -> Media {
        guard let image = value as? NSDictionary, let urlString = image["url"] as? String, let url = URL(string: urlString), let height = image["height"] as? Int, let width = image["width"] as? Int else {
            throw MapperError.convertibleError(value: value, type: Media.self)
        }
        if let imageType = image["type"] as? String, imageType == MediaType.photo.rawValue {
            return Media(url: url, height: height, width: width, type: .photo)
        }
        if let imageType = image["type"] as? String, imageType == MediaType.video.rawValue {
            return Media(url: url, height: height, width: width, type: .video)
        }
        if let type = getMediaType(url: url) {
            return Media(url: url, height: height, width: width, type: type)
        }
        return Media(url: url, height: height, width: width, type: .photo)
    }
}
