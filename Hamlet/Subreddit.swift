//
//  Subreddit.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Alamofire

struct Subreddit {
    
}

extension Subreddit {
    
    static private func fetchListing(subreddit: String, sort: Listing.SortType, completion: @escaping (([Listing])->())) {
        Alamofire.request("https://api.reddit.com/r/\(subreddit)/\(sort.rawValue)").responseJSON { response in
            if let json = response.result.value as? NSDictionary, let data = json["data"] as? NSDictionary, let children = data["children"] as? NSArray {
                guard let listings = Listing.from(children) else {
                    return completion([])
                }
                completion(listings)
            } else {
                completion([])
            }
        }
    }
    
    static func fetchHotListing(subreddit: String, completion: @escaping (([Listing])->())) {
        fetchListing(subreddit: subreddit, sort: .hot, completion: completion)
    }
    
    static func fetchNewListing(subreddit: String, completion: @escaping (([Listing])->())) {
        fetchListing(subreddit: subreddit, sort: .new, completion: completion)
    }
    
    static func fetchTopListing(subreddit: String, completion: @escaping (([Listing])->())) {
        fetchListing(subreddit: subreddit, sort: .top, completion: completion)
    }
    
}
