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
    
    enum SortType: String {
        case hot = "hot"
        case new = "new"
        case top = "top"
        case controversial = "controversial"
    }
    
    let author: String?
    let authorFlair: String?
    let createdDate: Double?
    let downs: Int?
    let ups: Int?
    let title: String?
    let url: URL?
    let isSticky: Bool?
    let score: Int?
    let isSaved: Bool?
    let isNSFW: Bool?
    let numberOfComments: Int?
    let flair: String?
    let thumbnail: String?
    let domain: String?
    let description: String?
    let name: String?
    let isVisited: Bool?
    let kind: String?
    let previewImage: Preview?
    let subreddit: String?
    
    init(map: Mapper) throws {
        kind = map.optionalFrom("kind")
        author = map.optionalFrom("data.author")
        authorFlair = map.optionalFrom("data.author_flair_text")
        createdDate = map.optionalFrom("data.created_utc")
        downs = map.optionalFrom("data.downs")
        ups = map.optionalFrom("data.ups")
        title = map.optionalFrom("data.title")
        url = map.optionalFrom("data.url")
        isSticky = map.optionalFrom("data.stickied")
        score = map.optionalFrom("data.score")
        isSaved = map.optionalFrom("data.saved")
        isNSFW = map.optionalFrom("data.over_18")
        numberOfComments = map.optionalFrom("data.num_comments")
        flair = map.optionalFrom("data.link_flair_text")
        thumbnail = map.optionalFrom("data.thumbnail")
        domain = map.optionalFrom("data.domain")
        description = map.optionalFrom("data.selftext")
        name = map.optionalFrom("data.name")
        isVisited = map.optionalFrom("data.visited")
        previewImage = map.optionalFrom("data.preview")
        subreddit = map.optionalFrom("data.subreddit")
    }
}
