//
//  FeedDetailCommentViewModel.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation

struct FeedDetailCommentViewModel: Equatable {
    let body: String
    let metaInformation: String
    let primaryKey: String
    
    static func ==(lhs: FeedDetailCommentViewModel, rhs: FeedDetailCommentViewModel) -> Bool {
        return lhs.primaryKey == rhs.primaryKey
    }
}
