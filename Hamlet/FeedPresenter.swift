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
import AsyncDisplayKit

class FeedPresenter {

    var subreddit: String
    var sort: Listing.SortType

    var cachedListings = [Listing]()
    var feedItems = [FeedViewModel]()
    var searchItems = [FeedViewModel]()
    
    var onDidTapFlashMessage: ((Listing)->Void)?
    var onDidTapViewDiscussion: ((Listing, FeedViewModel)->Void)?
    
    let debounce = Debouncer(interval: 0.2)
    
    init(subredditID: String, sort: Listing.SortType) {
        self.sort = sort
        subreddit = subredditID
    }
    
    func fetchData(completion: @escaping ()->Void) {
        let weakSelf = self
        Subreddit.fetchListing(subreddit: subreddit, sort: sort, after: cachedListings.last?.name, limit: 25) { (listings) in
            weakSelf.cachedListings.append(contentsOf: listings)
            let mappedFeedItems = weakSelf.getFeedItems(from: listings)
            
            weakSelf.fetchRemoteMedia(items: mappedFeedItems) { (items) in
                weakSelf.feedItems.append(contentsOf: items)
                completion()
            }
        }
    }
    
    func getListing(key: String) -> Listing? {
        for listing in cachedListings {
            if listing.name == key {
                return listing
            }
        }
        return nil
    }
    
    func fetchRemoteMedia(items: [FeedViewModel], completion: @escaping ([FeedViewModel])->Void) {
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
                group.enter()
                newItems.append(item)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { 
            completion(newItems)
        }
    }
    
    func getFeedItems(from: [Listing]) -> [FeedViewModel] {
        let items = from.map({ (listing) -> FeedViewModel in
            let flashColor: UIColor? = listing.isAlbum ? UIColor(red: 50, green: 92, blue: 134) : nil
            let flashMessage: String? = listing.isAlbum ? "album".uppercased() : nil
            let actionColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
            let domainSubmissionText = listing.domainExcludeSubreddit.isEmpty ? "" : "\n\n\(listing.domainExcludeSubreddit.uppercased())"
            let submissionText = "Submitted \(listing.dateCreated.timeAgo(numericDates: true)) by \(listing.author) on r/\(listing.subreddit)\(domainSubmissionText)"
            let upvotes = listing.ups
            
            var media: Media? = nil
            
            if let preview = listing.previewMedia {
                
                var url: URL? = nil
                let type: Media.MediaType = listing.isVideo ? .video : .photo
                var poster: URL? = nil
                
                if type == .video {
                    switch listing.domain {
                    case Listing.Domain.imgur.rawValue:
                        url = Imgur.replaceGIFV(url: listing.url)
                        poster = preview.variantSource.source.url
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
                    media = Media(url: url, height: preview.variantSource.source.height, width: preview.variantSource.source.width, type: type, poster: poster)
                }
            }
            
            return FeedViewModel(title: listing.title, description: listing.descriptionEscaped, flashMessage: flashMessage, flashColor: flashColor, author: listing.author, subreddit: listing.subreddit, domain: listing.domain, media: media, actionColor: actionColor, submission: submissionText, linkUrl: listing.url, primaryKey: listing.name, upvotes: upvotes)
        })
        return items
    }
}

extension FeedPresenter: FeedControllerDelegate {
    
    func dataClear() {
        searchItems = []
        feedItems = []
        cachedListings = []
    }

    func didLoad(tableNode: ASTableNode) {
        dataFetch(tableNode: tableNode)
    }
    
    func dataSource() -> [FeedViewModel] { return feedItems }
    
    func didTapFlashMessage(tableNode: ASTableNode, atIndex: Int) {
        if let onDidTapFlashMessage = onDidTapFlashMessage, let listing = getListing(key: feedItems[atIndex].primaryKey) {
            onDidTapFlashMessage(listing)
        }
    }
    
    func didTapViewDiscussion(tableNode: ASTableNode, atIndex index: Int) {
        if let onDidTapViewDiscussion = onDidTapViewDiscussion, let listing = getListing(key: feedItems[index].primaryKey) {
            onDidTapViewDiscussion(listing, feedItems[index])
        }
    }
    
    func dataFetchNext(completion: @escaping ([FeedViewModel]) -> Void) {
        Subreddit.fetchListing(subreddit: subreddit, sort: sort, after: cachedListings.last?.name, limit: 25) { (listings) in
            let weakSelf = self
            weakSelf.cachedListings.append(contentsOf: listings)
            let mappedFeedItems = weakSelf.getFeedItems(from: listings)
            
            weakSelf.fetchRemoteMedia(items: mappedFeedItems) { (items) in
                weakSelf.feedItems.append(contentsOf: items)
                completion(items)
            }
        }
    }
    
    func dataFetch(tableNode: ASTableNode) {
        fetchData() {
            tableNode.reloadData()
        }
    }
    
    func didSearch(tableNode: ASTableNode, text: String) {
        let weakSelf = self
        debounce.callback = {
            Subreddit.searchListings(subreddit: weakSelf.subreddit, query: text, after: nil, limit: 100, completion: { (listings: [Listing]) in
                weakSelf.searchItems = weakSelf.getFeedItems(from: listings)
                tableNode.reloadData()
            })
        }
    }
    
    func didCancelSearch(tableNode: ASTableNode) {
        searchItems = []
        tableNode.reloadData()
    }
}
