//
//  FeedViewModel.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/5/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

struct FeedViewModel {
    enum MediaType: Int {
        case photo = 0
        case video = 1
        case none = 2
    }
    let title: String
    let description: String
    let flashMessage: String?
    let flashColor: UIColor?
    let author: String
    let subreddit: String
    let domain: String
    var media: Media?
    let actionColor: UIColor
    let submission: String
    let linkUrl: URL?
    let primaryKey: String
    let upvotes: Int
}

extension FeedViewModel {
    
    enum CellType: Int {
        case title = 0
        case photo = 1
        case flash = 2
        case action = 3
        case upvotes = 4
        case description = 5
        case submission = 6
        case blank = 7
        case separator = 8
        case mediaDescription = 9
        case video = 10
    }
    
    func getNodeTypeOrder() -> [CellType] {
        var types = [CellType]()
        types.append(.title)
        
        if let media = self.media {
            switch media.type {
            case .photo:
                types.append(.photo)
            case .video:
                types.append(.video)
            }
        } else if self.description.characters.count > 0 {
            types.append(.mediaDescription)
        }
        
        if self.flashColor != nil || self.flashMessage != nil { types.append(.flash) }
        types.append(.action)
        types.append(.separator)
        if self.upvotes > 0 { types.append(.upvotes) }
        
        if self.description.characters.count > 0 && !types.contains(.mediaDescription) { types.append(.description) }
        
        if !self.submission.isEmpty { types.append(.submission) }
        types.append(.blank)
        return types
    }
}
