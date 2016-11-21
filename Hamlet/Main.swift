//
//  Main.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/21/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class Main {
    
    let slideMenuController: SlideMenuViewController
    
    let listNavigation: ASNavigationController
    let feedNavigation: ASNavigationController

    let listPresenter = SubredditListPresenter()
    let feedPresenter = FeedPresenter(subredditID: "all", sort: .hot)

    let listController = SubredditListViewController()
    let feedController = FeedViewController()
    
    init() {
        listNavigation = ASNavigationController(rootViewController: listController)
        feedNavigation = ASNavigationController(rootViewController: feedController)
        
        slideMenuController = SlideMenuViewController(main: feedNavigation, menu: listNavigation)
        
        listController.delegate = listPresenter
        listNavigation.navigationBar.alpha = 1.0
        listNavigation.navigationBar.barTintColor = .white
        listNavigation.navigationBar.tintColor = .darkText
        listNavigation.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)]

        feedController.delegate = feedPresenter
        feedController.searchController.searchBar.placeholder = "Search Posts in r/all"

        feedNavigation.navigationBar.alpha = 1.0
        feedNavigation.navigationBar.barTintColor = .white
        feedNavigation.navigationBar.tintColor = .darkText
        feedNavigation.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)]
        feedNavigation.hidesBarsOnSwipe = true
        feedNavigation.view.layer.shadowOpacity = 0.6
    }
    
    func run() {
        let weakSelf = self
        
        feedPresenter.onDidTapFlashMessage = { (listing: Listing) in
            let albumPresenter = AlbumPresenter(url: listing.url)
            let albumController = AlbumViewController()
            albumController.delegate = albumPresenter
            weakSelf.feedNavigation.pushViewController(albumController, animated: true)
            weakSelf.feedNavigation.setNavigationBarHidden(false, animated: true)
        }
        
        feedPresenter.onDidTapViewDiscussion = { (listing: Listing, model: FeedViewModel) in
            let discussionPresenter = ListingDiscussionPresenter(listingId: listing.id, subreddit: listing.subreddit, sort: .top, feedViewModel: model)
            let discussionController = FeedDetailViewController()
            discussionController.delegate = discussionPresenter
            weakSelf.feedNavigation.pushViewController(discussionController, animated: true)
            weakSelf.feedNavigation.setNavigationBarHidden(false, animated: true)
        }
        
        listPresenter.onDidSelectSubreddit = { id in
            
            if weakSelf.feedNavigation.viewControllers.count != 1 {
                weakSelf.feedNavigation.popToRootViewController(animated: true)
            }
            
            weakSelf.feedPresenter.subreddit = id
            
            weakSelf.feedController.searchController.searchBar.placeholder = "Search Posts in r/\(id)"
            weakSelf.feedController.searchController.searchBar.text = ""
            
            weakSelf.listController.searchController.searchBar.resignFirstResponder()
            weakSelf.listController.searchController.searchBar.setShowsCancelButton(false, animated: true)
            
            weakSelf.feedNavigation.setNavigationBarHidden(false, animated: true)
            
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
                weakSelf.slideMenuController.closeLeftPanel() { _ in
                    weakSelf.feedController.clear()
                    weakSelf.feedController.reload()
                }
            })
        }
    }
}
