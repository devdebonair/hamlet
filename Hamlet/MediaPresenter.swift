//
//  MediaPresenter.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/26/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol MediaPresenterDelegate {
    func didFetchItems(range: CountableRange<Int>)
}

class MediaPresenter {
    
    var feedPresenter: FeedPresenter
    var delegate: MediaPresenterDelegate!
    
    var cache: [String:Media] {
        return feedPresenter.cacheModel.mediaCache
    }
    
    var keys: [String] {
        var tempKeys = [String]()
        for key in feedPresenter.cacheModel.order {
            if cache[key] != nil {
                tempKeys.append(key)
            }
        }
        return tempKeys
    }
    
    init(feedPresenter: FeedPresenter) {
        self.feedPresenter = feedPresenter
        self.delegate = self
    }
    
}

extension MediaPresenter: MediaViewControllerDelegate {
    func dataSource() -> [String] {
        return keys
    }
    
    func dataAt(key: String) -> MediaViewModel {
        if let media = cache[key] {
            return MediaViewModel(media: media, primaryKey: key)
        }
        return MediaViewModel(media: Media(url: nil, height: 0, width: 0), primaryKey: "")
    }
    
    func dataFetch(tableNode: ASCollectionNode) {
        return
    }
    
    func dataFetchNext(completion: @escaping (CountableRange<Int>) -> Void) {
        let lower = numberOfItems()
        feedPresenter.dataFetchNext { range in
            let upper = lower + (self.numberOfItems() - lower)
            self.delegate.didFetchItems(range: range)
            completion(lower..<upper)
        }
    }
    
    func numberOfItems() -> Int {
        return cache.count
    }
}

extension MediaPresenter: MediaPresenterDelegate {
    func didFetchItems(range: CountableRange<Int>) {}
}
