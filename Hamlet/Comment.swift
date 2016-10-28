//
//  Comment.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/27/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import Mapper
import Alamofire

struct Comment: Mappable {
    
    typealias ArticleID = String
    typealias SubredditName = String
    
    enum Sort: String {
        case confidence = "confidence"
        case top = "top"
        case new = "new"
        case controversial = "controversial"
        case old = "old"
        case random = "random"
        case qa = "qa"
        case live = "live"
    }
    
    let subredditId: String
    let linkId: String
    let id: String
    let gilded: Int
    let author: String
    let parentId: String
    let score: Int
    let controversiality: Int
    let body: String
    let edited: Bool
    let downs: Int
    let stickied: Bool
    let subreddit: String
    let name: String
    let created: Double
    let authorFlairText: String
    let ups: Int
    let replies: [Comment]
    
    init(map: Mapper) throws {
        subredditId = map.optionalFrom("data.subreddit_id") ?? ""
        linkId = map.optionalFrom("data.link_id") ?? ""
        id = map.optionalFrom("data.id") ?? ""
        gilded = map.optionalFrom("data.gilded") ?? 0
        author = map.optionalFrom("data.author") ?? ""
        parentId = map.optionalFrom("data.parent_id") ?? ""
        score = map.optionalFrom("data.score") ?? 0
        controversiality = map.optionalFrom("data.controversiality") ?? 0
        body = map.optionalFrom("data.body") ?? ""
        edited = map.optionalFrom("data.edited") ?? false
        downs = map.optionalFrom("data.downs") ?? 0
        stickied = map.optionalFrom("data.stickied") ?? false
        subreddit = map.optionalFrom("data.subreddit") ?? ""
        name = map.optionalFrom("data.name") ?? ""
        created = map.optionalFrom("created") ?? 0.0
        authorFlairText = map.optionalFrom("data.author_flair_text") ?? ""
        ups = map.optionalFrom("data.ups") ?? 0
        replies = map.optionalFrom("data.replies.data.children") ?? [Comment]()
    }
    
    static func fetch(from id: ArticleID, subreddit: SubredditName, sort: Sort = .top, completion: @escaping ([Comment])->Void) {
        let url = "https://api.reddit.com/r/\(subreddit)/comments/\(id)/\(sort.rawValue)"
        let headers = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            guard let jsonArray = response.result.value as? NSArray, jsonArray.count > 1, let jsonComments = jsonArray[1] as? NSDictionary, let data = jsonComments["data"] as? NSDictionary, let commentData = data["children"] as? NSArray, let comments = Comment.from(commentData) else { return completion([]) }
            return completion(comments)
        }
    }
}
