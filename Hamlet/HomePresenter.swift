//
//  HomePresenter.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/5/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class HomePresenter: FeedControllerDelegate {
    
    let SUBREDDIT = "pics"
    
    var feedItems = [FeedViewModel]() {
        didSet {
            var imageURLs = [URL]()
            feedItems.forEach { (model) in
                guard let media = model.media, let url = media.url, media.type == .photo  else { return }
                imageURLs.append(url)
            }
            let prefetcher = ImagePrefetcher(urls: imageURLs)
            prefetcher.start()
        }
    }
    
    var cachedListings = [Listing]()
    let viewController: FeedViewController = {
        let controller = FeedViewController()
        return controller
    }()
    
    init() {
        viewController.delegate = self
    }
    
    func dataSource() -> [FeedViewModel] { return feedItems }
    func didLoad() { fetchData(completion: loadTable) }
    func didReachEnd() { fetchData(completion: loadTable) }
    
    func fetchData(completion: @escaping ([Listing])->Void) {
        Subreddit.fetchListing(subreddit: SUBREDDIT, sort: .hot, after: cachedListings.last?.name, limit: 50) { (listings) in
            self.cachedListings = listings
            completion(listings)
        }
    }
    
    func loadTable(listings: [Listing]) {
        let mappedFeedItems = self.loadFeedItems(listings: listings)
        
        self.viewController.tableView.beginUpdates()
        let min = self.feedItems.count
        let max = self.feedItems.count + mappedFeedItems.count
        let indexSet = IndexSet(integersIn: min..<max)
        self.viewController.tableView.insertSections(indexSet, with: .none)
        self.feedItems.append(contentsOf: mappedFeedItems)
        
        let beforeContentSize = self.viewController.tableView.contentSize
        self.viewController.tableView.reloadData()
        let afterContentSize = self.viewController.tableView.contentSize
        let afterContentOffset = self.viewController.tableView.contentOffset
        let newContentOffset = CGPoint(x: afterContentOffset.x, y: afterContentOffset.y + afterContentSize.height - beforeContentSize.height)
        self.viewController.tableView.contentOffset = newContentOffset
        self.viewController.tableView.endUpdates()
    }
    
    func loadFeedItems(listings: [Listing]) -> [FeedViewModel] {
        let items = listings.map({ (listing) -> FeedViewModel in
            let flashColor: UIColor? = listing.isAlbum ? UIColor(red: 25/255, green: 181/255, blue: 254/255, alpha: 1.0) : nil
            let flashMessage: String? = listing.isAlbum ? "album".uppercased() : nil
            let actionColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
            var media: Media? = nil
            
            if let preview = listing.previewMedia {
                let url: URL?
                
                if listing.isVideo {
                    switch listing.domain {
                    case Listing.Domain.imgur.rawValue:
                        url = Imgur.replaceGIFV(url: listing.url)
                    case Listing.Domain.reddit.rawValue:
                        url = preview.variantMP4?.source.url
                    case Listing.Domain.gfycat.rawValue:
                        url = listing.url
                    default:
                        if let mp4Url = preview.variantMP4?.source.url {
                            url = mp4Url
                        } else {
                            url = nil
                        }
                        
                    }
                } else {
                    if listing.domain.lowercased() == Listing.Domain.imgur.rawValue.lowercased() {
                        url = listing.url
                    } else {
                        url = preview.variantSource.source.url
                    }
                }
                
                if let url = url {
                    media = Media(url: url, height: preview.variantSource.source.height, width: preview.variantSource.source.width, type: nil)
                }
            }
            
            let domainSubmissionText = listing.domainExcludeSubreddit.isEmpty ? "" : "\n\n\(listing.domainExcludeSubreddit.uppercased())"
            let submissionText = "Submitted 1 hour ago by \(listing.author) on r/\(listing.subreddit)\(domainSubmissionText)"
            return FeedViewModel(title: listing.title, description: listing.descriptionEscaped, flashMessage: flashMessage, flashColor: flashColor, author: listing.author, subreddit: listing.subreddit, domain: listing.domain, media: media, actionColor: actionColor, submission: submissionText, linkUrl: listing.url, primaryKey: listing.name)
        })
        return items
    }

}
