//
//  Listing.swift
//  Hamlet
//
//  Created by Vincent Moore on 9/29/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper
import Alamofire

struct Listing: Mappable {
    
    let VALID_VIDEO_FORMATS = ["gifv", "mov", "mp4"]
    
    enum SortType: String {
        case hot = "hot"
        case new = "new"
        case top = "top"
        case rising = "rising"
        case controversial = "controversial"
    }
    
    enum Domain: String {
        case imgur = "i.imgur.com"
        case gfycat = "gfycat.com"
        case reddit = "i.redd.it"
    }
    
    let author: String
    let authorFlair: String
    let createdDate: Double
    let downs: Int
    let ups: Int
    let title: String
    let url: URL?
    let isSticky: Bool
    let score: Int
    let isSaved: Bool
    let isNSFW: Bool
    let numberOfComments: Int
    let flair: String
    let thumbnail: URL?
    let domain: String
    let description: String
    let name: String
    let isVisited: Bool
    let kind: String
    let previewMedia: Preview?
    let subreddit: String
    let id: String
    
    var dateCreated: Date { return Date(timeIntervalSince1970: createdDate) }
    
    var descriptionEscaped: String {
        return description.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "#", with: "")
    }
    
    var domainExcludeSubreddit: String {
        return domain.lowercased().contains("self.\(subreddit.lowercased())") ? "" : domain.replacingOccurrences(of: " ", with: "")
    }
    
    var isVideo: Bool {
        guard let url = url else {
            return false
        }
        
        let fileExtension = url.pathExtension
        
        var hasVideoVariant = false
        if let previewMedia = previewMedia, let _ = previewMedia.variantMP4 {
            hasVideoVariant = true
        }

        return (VALID_VIDEO_FORMATS.contains(fileExtension) || domain == Domain.gfycat.rawValue || hasVideoVariant)
    }
    
    var isAlbum: Bool { return Imgur.isAlbum(url: url) }
    
    init(map: Mapper) throws {
        id = map.optionalFrom("data.id") ?? ""
        kind = map.optionalFrom("kind") ?? ""
        author = map.optionalFrom("data.author") ?? ""
        authorFlair = map.optionalFrom("data.author_flair_text") ?? ""
        createdDate = map.optionalFrom("data.created_utc") ?? 0.0
        downs = map.optionalFrom("data.downs") ?? 0
        ups = map.optionalFrom("data.ups") ?? 0
        title = map.optionalFrom("data.title") ?? ""
        url = map.optionalFrom("data.url")
        isSticky = map.optionalFrom("data.stickied") ?? false
        score = map.optionalFrom("data.score") ?? 0
        isSaved = map.optionalFrom("data.saved") ?? false
        isNSFW = map.optionalFrom("data.over_18") ?? false
        numberOfComments = map.optionalFrom("data.num_comments") ?? 0
        flair = map.optionalFrom("data.link_flair_text") ?? ""
        thumbnail = map.optionalFrom("data.thumbnail")
        domain = map.optionalFrom("data.domain") ?? ""
        description = map.optionalFrom("data.selftext") ?? ""
        name = map.optionalFrom("data.name") ?? ""
        isVisited = map.optionalFrom("data.visited") ?? false
        previewMedia = map.optionalFrom("data.preview")
        subreddit = map.optionalFrom("data.subreddit") ?? ""
    }
}
