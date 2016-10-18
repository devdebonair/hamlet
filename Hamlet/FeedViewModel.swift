//
//  FeedViewModel.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/5/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
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
}
