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
        feedPresenter.delegate = self
        slideMenuController.delegate = self
        
        listController.delegate = listPresenter
        listNavigation.navigationBar.alpha = 1.0
        listNavigation.navigationBar.barTintColor = .white
        listNavigation.navigationBar.tintColor = .darkText
        listNavigation.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)]
        listNavigation.navigationBar.isTranslucent = false

        feedController.delegate = feedPresenter
        feedController.searchController.searchBar.placeholder = "Search Posts in r/all"

        feedNavigation.navigationBar.alpha = 1.0
        feedNavigation.navigationBar.barTintColor = .white
        feedNavigation.navigationBar.tintColor = .darkText
        feedNavigation.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)]
        feedNavigation.hidesBarsOnSwipe = true
        feedNavigation.view.layer.shadowOffset = CGSize(width: -1.0, height: 0.0)
        feedNavigation.view.layer.shadowOpacity = 0.1
        feedNavigation.navigationBar.isTranslucent = false
    }
}

extension Main: SlideMenuViewControllerDelegate {
    func didBeginSliding() {
        if listController.searchController.searchBar.isFirstResponder {
            listController.searchController.searchBar.resignFirstResponder()
        }
    }
    
    func didEndSliding(state: SlideMenuViewController.SlideMenuState) {
//        UIApplication.shared.isStatusBarHidden = state == .menu
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
                
                self.listController.searchController.searchBar.text = ""
                self.listController.scrollToTop()
                self.listPresenter.searchClear()
            }
        })
    }
    
    func didBeginSearch() {
        slideMenuController.expandMenu()
    }
    
    func didEndSearch() {
        slideMenuController.contractMenu()
    }
}

extension Main: FeedPresenterDelegate {
    func didTapViewDiscussion(listing: Listing, model: FeedViewModel) {
        let discussionPresenter = ListingDiscussionPresenter(listingId: listing.id, subreddit: listing.subreddit, sort: .top, feedViewModel: model)
        let discussionController = FeedDetailViewController()
        discussionController.delegate = discussionPresenter
        feedNavigation.pushViewController(discussionController, animated: true)
        feedNavigation.setNavigationBarHidden(false, animated: true)
    }
    
    func didTapFlashMessage(listing: Listing) {
        let albumPresenter = AlbumPresenter(url: listing.url)
        let albumController = AlbumViewController()
        albumController.delegate = albumPresenter
        feedNavigation.pushViewController(albumController, animated: true)
        feedNavigation.setNavigationBarHidden(false, animated: true)
    }
}
