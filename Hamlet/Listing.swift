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
    
    let author: String
    let authorFlair: String?
    let createdDate: Int
    let downs: Int
    let ups: Int
    let title: String
    let url: String
    let isSticky: Bool?
    let score: Int
    let isSaved: Bool
    let isNSFW: Bool
    let numberOfComments: Int
    let flair: String
    let thumbnail: String
    let domain: String
    let description: String
    let name: String
    let isVisited: Bool
    let kind: String
    
    init(map: Mapper) throws {
        try kind = map.from("kind")
        try author = map.from("data.author")
        authorFlair = map.optionalFrom("data.author_flair_text")
        try createdDate = map.from("data.created_utc")
        try downs = map.from("data.downs")
        try ups = map.from("data.ups")
        try title = map.from("data.title")
        try url = map.from("data.url")
        try isSticky = map.from("data.stickied")
        try score = map.from("data.score")
        try isSaved = map.from("data.saved")
        try isNSFW = map.from("data.over_18")
        try numberOfComments = map.from("data.num_comments")
        try flair = map.from("data.link_flair_text")
        try thumbnail = map.from("data.thumbnail")
        try domain = map.from("data.domain")
        try description = map.from("data.selftext")
        try name = map.from("data.name")
        try isVisited = map.from("data.visited")
    }
}
