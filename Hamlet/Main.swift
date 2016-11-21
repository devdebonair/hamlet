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
        
        listPresenter.delegate = self
        slideMenuController.delegate = self
        
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
    }
}

extension Main: SlideMenuViewControllerDelegate {
    func didBeginSliding() {
        if listController.searchController.searchBar.isFirstResponder {
            listController.searchController.searchBar.resignFirstResponder()
        }
    }
}

extension Main: SubredditListPresenterDelegate {
    func didSelectSubreddit(id: String) {
        if feedNavigation.viewControllers.count != 1 {
            feedNavigation.popToRootViewController(animated: true)
        }
        
        feedPresenter.subreddit = id
        
        feedController.searchController.searchBar.placeholder = "Search Posts in r/\(id)"
        feedController.searchController.searchBar.text = ""
        
        listController.searchController.searchBar.resignFirstResponder()
        listController.searchController.searchBar.setShowsCancelButton(false, animated: true)
        
        feedNavigation.setNavigationBarHidden(false, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
            self.slideMenuController.closeLeftPanel() { _ in
                self.feedController.clear()
                self.feedController.reload()
            }
        })
    }
}
