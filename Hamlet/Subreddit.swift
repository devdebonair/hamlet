//
//  Subreddit.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper
import Alamofire

struct Subreddit: Mappable {
    enum SortType: String {
        case popular = "popular"
        case new = "new"
        case gold = "gold"
        case def = "default"
    }
    
    let bannerImageUrl: URL?
    let submitRules: String
    let displayName: String
    let headerImageUrl: URL?
    let title: String
    let isNSFW: Bool
    let iconImageUrl: URL?
    let headerTitle: String
    let description: String
    let numberOfSubscribers: Int
    let keyColorHex: String
    let name: String
    let createdDate: Double
    let url: String
    let publicDescription: String
    let type: String
    let kind: String
    
    init(map: Mapper) throws {
        bannerImageUrl = map.optionalFrom("data.banner_img")
        submitRules = map.optionalFrom("data.submit_text") ?? ""
        displayName = map.optionalFrom("data.display_name") ?? ""
        headerImageUrl = map.optionalFrom("data.header_img")
        title = map.optionalFrom("data.title") ?? ""
        isNSFW = map.optionalFrom("data.over18") ?? false
        iconImageUrl = map.optionalFrom("data.icon_img")
        headerTitle = map.optionalFrom("data.header_title") ?? ""
        description = map.optionalFrom("data.description") ?? ""
        numberOfSubscribers = map.optionalFrom("data.subscribers") ?? 0
        keyColorHex = map.optionalFrom("data.key_color") ?? ""
        name = map.optionalFrom("data.name") ?? ""
        createdDate = map.optionalFrom("data.created_utc") ?? 0.0
        url = map.optionalFrom("data.url") ?? ""
        publicDescription = map.optionalFrom("data.public_description") ?? ""
        type = map.optionalFrom("data.subreddit_type") ?? ""
        kind = map.optionalFrom("kind") ?? ""
    }
}

extension Subreddit {
    
    static func fetchHotListing(subreddit: String, completion: @escaping ([Listing])->Void) {
        fetchListing(subreddit: subreddit, sort: .hot, completion: completion)
    }
    
    static func fetchNewListing(subreddit: String, completion: @escaping ([Listing])->Void) {
        fetchListing(subreddit: subreddit, sort: .new, completion: completion)
    }
    
    static func fetchTopListing(subreddit: String, completion: @escaping ([Listing])->Void) {
        fetchListing(subreddit: subreddit, sort: .top, completion: completion)
    }
    
    static func fetchControversialListing(subreddit: String, completion: @escaping ([Listing])->Void) {
        fetchListing(subreddit: subreddit, sort: .controversial, completion: completion)
    }
    
    static func fetchListing(subreddit: String, sort: Listing.SortType, after: String? = nil, limit: Int? = nil, completion: @escaping (([Listing])->())) {
        var queries = [String:String]()
        if let after = after {
            queries["after"] = after
        }
        if let limit = limit {
            queries["limit"] = String(limit)
        }
        let url = "https://api.reddit.com/r/\(subreddit)/\(sort.rawValue)"
        let headers = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36"]
        Alamofire.request(url, method: .get, parameters: queries, headers: headers).responseJSON { (response) in
            completion(responseParser(response: response, target: Listing.self))
        }
    }
    
    static func searchListings(subreddit: String, query: String, after: String? = nil, limit: Int? = nil, completion: @escaping ([Listing])->Void) {
        let url = "https://api.reddit.com/r/\(subreddit)/search"
        let headers = ["User-Agent": HEADER_USER_AGENT]
        var queries = ["q": query]
        if let after = after {
            queries["after"] = after
        }
        if let limit = limit {
            queries["limit"] = String(limit)
        }
        Alamofire.request(url, method: .get, parameters: queries, headers: headers).responseJSON { (response) in
            completion(responseParser(response: response, target: Listing.self))
        }
    }
    
    static func searchPopular(completion: @escaping ([Subreddit])->Void) {
        searchWhere(sort: .popular, completion: completion)
    }
    
    static func searchNew(completion: @escaping ([Subreddit])->Void) {
        searchWhere(sort: .new, completion: completion)
    }
    
    static func searchGold(completion: @escaping ([Subreddit])->Void) {
        searchWhere(sort: .gold, completion: completion)
    }
    
    static func searchDefault(completion: @escaping ([Subreddit])->Void) {
        searchWhere(sort: .def, completion: completion)
    }
    
    static func search(query: String, sort: SortType = .popular, completion: @escaping ([Subreddit])->Void) {
        let parameters = ["q": query]
        let url = "https://api.reddit.com/subreddits/search"
        let headers = ["User-Agent": HEADER_USER_AGENT]
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            completion(responseParser(response: response, target: Subreddit.self))
        }
    }
    
    static private func searchWhere(sort: SortType, completion: @escaping ([Subreddit])->Void) {
        Alamofire.request("https://api.reddit.com/subreddits/\(sort.rawValue)").responseJSON { response in
            completion(responseParser(response: response, target: Subreddit.self))
        }
    }
    
    static private func responseParser <T> (response: DataResponse<Any>, target: T.Type) -> [T] where T:Mappable {
        if let json = response.result.value as? NSDictionary, let data = json["data"] as? NSDictionary, let children = data["children"] as? NSArray, let responseData = T.from(children) {
            return responseData
        } else {
            return []
        }
    }
    
}
