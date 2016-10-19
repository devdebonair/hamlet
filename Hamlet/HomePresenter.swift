//
//  HomePresenter.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/5/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class HomePresenter: FeedControllerDelegate {
    let SUBREDDIT = "anime"
    
    let viewController: FeedViewController = {
        let controller = FeedViewController()
        return controller
    }()
    
    // Protocols
    func dataSource() -> [FeedViewModel] { return feedItems }
    func didLoad() { fetchData(completion: loadTable) }
    func didReachEnd() { fetchData(completion: loadTable) }

    var cachedListings = [Listing]()
    
    // Datasource
    var feedItems = [FeedViewModel]() {
        didSet {
            var imageURLs = [URL]()
            feedItems.forEach { (model) in
                guard let media = model.media else { return }
                if let url = media.url, media.type == .photo {
                    imageURLs.append(url)
                } else if let poster = media.poster, media.type == .video {
                    imageURLs.append(poster)
                }
            }
            PINRemoteImageManager.shared().prefetchImages(with: imageURLs)
        }
    }
    
    init() {
        viewController.delegate = self
    }
    
    private func fetchData(completion: @escaping ([Listing])->Void) {
        Subreddit.fetchListing(subreddit: SUBREDDIT, sort: .hot, after: cachedListings.last?.name, limit: 50) { (listings) in
            self.cachedListings = listings
            completion(listings)
        }
    }
    
    private func loadTable(listings: [Listing]) {
        let mappedFeedItems = self.loadFeedItems(listings: listings)
        
        fetchRemoteMedia(items: mappedFeedItems) { (items) in
            self.viewController.tableView.beginUpdates()
            
            let min = self.feedItems.count
            let max = self.feedItems.count + items.count
            let indexSet = IndexSet(integersIn: min..<max)
            self.viewController.tableView.insertSections(indexSet, with: .none)
            self.feedItems.append(contentsOf: items)
            
            // keep tableview from scrolling to top
            let beforeContentSize = self.viewController.tableView.contentSize
            self.viewController.tableView.reloadData()
            let afterContentSize = self.viewController.tableView.contentSize
            let afterContentOffset = self.viewController.tableView.contentOffset
            let newContentOffset = CGPoint(x: afterContentOffset.x, y: afterContentOffset.y + afterContentSize.height - beforeContentSize.height)
            self.viewController.tableView.contentOffset = newContentOffset
            
            self.viewController.tableView.endUpdates()
        }
        
    }
    
    private func fetchRemoteMedia(items: [FeedViewModel], completion: @escaping ([FeedViewModel])->Void) {
        let queue = DispatchQueue(label: "com.Hamlet.RemoteMediaFetch")
        let group = DispatchGroup()
        
        var newItems = [FeedViewModel]()
        
        for var item in items {
            if item.media == nil && Imgur.isImgurUrl(url: item.linkUrl) && !Imgur.isAlbum(url: item.linkUrl) {
                let url = item.linkUrl
                group.enter()
                queue.async(group: group) {
                    Imgur.getImage(url: url, completion: { (image) in
                        if let image = image {
                            let media = Media(url: image.link, height: image.height, width: image.width, type: .photo)
                            item.media = media
                            newItems.append(item)
                            group.leave()
                        }
                    })
                }
            } else if item.domain.lowercased().contains(Listing.Domain.gfycat.rawValue.lowercased()) {
                let url = item.linkUrl
                group.enter()
                queue.async(group: group) {
                    Gfycat.fetch(url: url, completion: { (gfycat) in
                        if let gfycat = gfycat, let width = gfycat.width, let height = gfycat.height {
                            let media = Media(url: gfycat.urlMobileMP4, height: height, width: width, type: .video, poster: gfycat.mobilePosterUrl)
                            item.media = media
                            newItems.append(item)
                        }
                        group.leave()
                    })
                }
            } else {
                newItems.append(item)
            }
        }
        
        group.notify(queue: .main) { 
            completion(newItems)
        }
    }
    
    private func loadFeedItems(listings: [Listing]) -> [FeedViewModel] {
        let items = listings.map({ (listing) -> FeedViewModel in
            
            let flashColor: UIColor? = listing.isAlbum ? UIColor(red: 50/255, green: 92/255, blue: 134/255, alpha: 1.0) : nil
            let flashMessage: String? = listing.isAlbum ? "album".uppercased() : nil
            let actionColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
            let domainSubmissionText = listing.domainExcludeSubreddit.isEmpty ? "" : "\n\n\(listing.domainExcludeSubreddit.uppercased())"
            let submissionText = "Submitted 1 hour ago by \(listing.author) on r/\(listing.subreddit)\(domainSubmissionText)"
            let upvotes = listing.ups
            
            var media: Media? = nil
            
            if let preview = listing.previewMedia {
                
                var url: URL? = nil
                let type: Media.MediaType = listing.isVideo ? .video : .photo
                
                if type == .video {
                    switch listing.domain {
                    case Listing.Domain.imgur.rawValue:
                        url = Imgur.replaceGIFV(url: listing.url)
                    case Listing.Domain.reddit.rawValue:
                        url = preview.variantMP4?.source.url
                    case Listing.Domain.gfycat.rawValue:
                        url = listing.url
                    default:
                        url = preview.variantMP4?.source.url
                    }
                } else {
                    if listing.domain.lowercased() == Listing.Domain.imgur.rawValue.lowercased() {
                        url = listing.url
                    } else if let gifSource = preview.variantGIF {
                        url = gifSource.source.url
                    } else {
                        url = preview.variantSource.source.url
                    }
                }
                
                if let url = url {
                    media = Media(url: url, height: preview.variantSource.source.height, width: preview.variantSource.source.width, type: type)
                }
            }
            
            return FeedViewModel(title: listing.title, description: listing.descriptionEscaped, flashMessage: flashMessage, flashColor: flashColor, author: listing.author, subreddit: listing.subreddit, domain: listing.domain, media: media, actionColor: actionColor, submission: submissionText, linkUrl: listing.url, primaryKey: listing.name, upvotes: upvotes)
        })
        return items
    }
}
