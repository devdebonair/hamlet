//
//  HomePresenter.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/5/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol FeedPresenterDelegate {
    func didTapViewDiscussion(listing: Listing, model: FeedViewModel)
}

class FeedPresenter {

    var subreddit: String
    var sort: Listing.SortType
    
    let cacheModel = FeedCache()
    let cacheSearch = FeedCache()
    
    var onDidTapFlashMessage: ((Listing)->Void)?
    
    var delegate: FeedPresenterDelegate!
    
    init(subredditID: String, sort: Listing.SortType) {
        self.sort = sort
        subreddit = subredditID
        delegate = self
    }
    
    func fetchSearchData(cache: FeedCache, sort: Listing.SortType, query: String, after: String?, completion: @escaping ([FeedModelContainer])->Void) {
        Subreddit.searchListings(subreddit: subreddit, query: query, after: after, limit: 25, completion: { (listings: [Listing]) in
            var models = [FeedModelContainer]()
            var keyOrder = [String]()
            for listing in listings {
                let model = FeedModelContainer(listing: listing)
                cache.add(model: model, at: model.feedItem.primaryKey)
                keyOrder.append(model.feedItem.primaryKey)
                models.append(model)
            }
            cache.order.append(contentsOf: keyOrder)
            completion(models)
        })
    }
    
    func fetchData(cache: FeedCache, sort: Listing.SortType, after: String?, completion: @escaping ([FeedModelContainer])->Void) {
        Subreddit.fetchListing(subreddit: subreddit, sort: sort, after: after, limit: 25) { (listings) in
            var models = [FeedModelContainer]()
            var keyOrder = [String]()
            for listing in listings {
                let model = FeedModelContainer(listing: listing)
                cache.add(model: model, at: model.feedItem.primaryKey)
                keyOrder.append(model.feedItem.primaryKey)
                models.append(model)
            }
            cache.order.append(contentsOf: keyOrder)
            completion(models)
        }
    }
    
    func fetchRemoteMedia(cache: FeedCache, models: [FeedModelContainer], completion: @escaping ()->Void) {
        let queue = DispatchQueue(label: "com.Hamlet.RemoteMediaFetch")
        let group = DispatchGroup()
        
        for model in models {
            let item = model.feedItem
            if item.media == nil && Imgur.isImgurUrl(url: item.linkUrl) && !Imgur.isAlbum(url: item.linkUrl) {
                let url = item.linkUrl
                group.enter()
                queue.async(group: group) {
                    Imgur.getImage(url: url, completion: { (image) in
                        if let image = image {
                            let media = Media(url: image.link, height: image.height, width: image.width, type: .photo)
                            cache.add(media: media, at: item.primaryKey)
                            group.leave()
                        }
                    })
                }
            }
            
            if item.domain.lowercased().contains(Listing.Domain.gfycat.rawValue.lowercased()) {
                let url = item.linkUrl
                group.enter()
                queue.async(group: group) {
                    Gfycat.fetch(url: url, completion: { (gfycat) in
                        if let gfycat = gfycat, let width = gfycat.width, let height = gfycat.height {
                            let media = Media(url: gfycat.urlMobileMP4, height: height, width: width, type: .video, poster: gfycat.mobilePosterUrl)
                            cache.add(media: media, at: item.primaryKey)
                        }
                        group.leave()
                    })
                }
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

extension FeedPresenter: FeedControllerDelegate {
    
    func searchClear() {
        cacheSearch.clear()
    }
    
    func dataModel(key: String) -> FeedViewModel {
        if !cacheSearch.isEmpty { return cacheSearch.getFeedModel(key: key)!.feedItem }
        return cacheModel.getFeedModel(key: key)!.feedItem
    }
    
    func numberOfModels() -> Int {
        if !cacheSearch.isEmpty { return cacheSearch.countModel }
        return cacheModel.countModel
    }
    
    func dataKeyOrder() -> [String] {
        if !cacheSearch.isEmpty { return cacheSearch.order }
        return cacheModel.order
    }
    
    func dataClear() {
        cacheModel.clear()
        cacheSearch.clear()
    }

    func didLoad(tableNode: ASTableNode) {
        dataFetch(tableNode: tableNode)
    }
    
    func didTapFlashMessage(tableNode: ASTableNode, atKey: String) {
        if let onDidTapFlashMessage = onDidTapFlashMessage, let model = cacheSearch.getFeedModel(key: atKey) ?? cacheModel.getFeedModel(key: atKey) {
            onDidTapFlashMessage(model.listing)
        }
    }
    
    func didTapViewDiscussion(tableNode: ASTableNode, atKey key: String) {
        if let model = cacheSearch.getFeedModel(key: key) ?? cacheModel.getFeedModel(key: key) {
            delegate.didTapViewDiscussion(listing: model.listing, model: model.feedItem)
        }
    }
    
    func dataFetchNext(completion: @escaping () -> Void) {
        let weakSelf = self
        fetchData(cache: cacheModel, sort: sort, after: cacheModel.order[cacheModel.order.count - 1]) { models in
            weakSelf.fetchRemoteMedia(cache: weakSelf.cacheModel, models: models) {
                completion()
            }
        }
    }
    
    func dataFetchNextSearch(text: String, completion: @escaping () -> Void) {
        let weakSelf = self
        fetchSearchData(cache: cacheSearch, sort: sort, query: text, after: cacheSearch.order[cacheSearch.order.count - 1]) { models in
            weakSelf.fetchRemoteMedia(cache: weakSelf.cacheSearch, models: models) {
                completion()
            }
        }
    }
    
    func dataFetch(tableNode: ASTableNode) {
        let weakSelf = self
        fetchData(cache: cacheModel, sort: sort, after: nil) { models in
            weakSelf.fetchRemoteMedia(cache: weakSelf.cacheModel, models: models) {
                tableNode.insertSections(IndexSet(integersIn: 0..<models.count), with: .middle)
            }
        }
    }
    
    func didSearch(tableNode: ASTableNode, text: String) {
        fetchSearchData(cache: cacheSearch, sort: sort, query: text, after: nil) {[weak self] models in
            if let weakSelf = self {
                weakSelf.fetchRemoteMedia(cache: weakSelf.cacheSearch, models: models) {
                    tableNode.reloadData()
                }
            }
        }
    }
    
    func didCancelSearch(tableNode: ASTableNode) {
        cacheSearch.clear()
        tableNode.reloadData()
    }
}

struct FeedModelContainer {
    let listing: Listing
    var feedItem: FeedViewModel
    
    init(listing: Listing) {
        self.listing = listing
        
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
        
        self.feedItem = FeedViewModel(title: listing.title, description: listing.descriptionEscaped, flashMessage: flashMessage, flashColor: flashColor, author: listing.author, subreddit: listing.subreddit, domain: listing.domain, media: media, actionColor: actionColor, submission: submissionText, linkUrl: listing.url, primaryKey: listing.name, upvotes: upvotes)
    }
}

class FeedCache {
    var mediaCache = [String:Media]()
    var modelCache = [String:FeedModelContainer]()
    var order = [String]()
    
    var isEmpty: Bool {
        return modelCache.isEmpty || order.isEmpty
    }
    
    var countModel: Int {
        return modelCache.count
    }
    
    func clear() {
        mediaCache = [:]
        modelCache = [:]
        order = []
    }
    
    func getFeedModel(key: String) -> FeedModelContainer? {
        let item = modelCache[key]
        if var item = item, let media = mediaCache[key] {
            item.feedItem.media = media
            return item
        }
        return item
    }
    
    func add(media: Media, at: String) {
        mediaCache[at] = media
    }
    
    func add(model: FeedModelContainer, at: String) {
        modelCache[at] = model
    }
}

extension FeedPresenter: FeedPresenterDelegate {
    func didTapViewDiscussion(listing: Listing, model: FeedViewModel) {}
}
