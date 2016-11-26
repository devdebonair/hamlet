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
        feedNavigation.view.layer.shadowOffset = CGSize(width: -0.2, height: 0.0)
        feedNavigation.view.layer.shadowOpacity = 0.4
        feedNavigation.navigationBar.isTranslucent = false
        
        let barItems = [
            UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(openSwag)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Media", style: .plain, target: self, action: #selector(openSwagger)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(openSwag)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSwag)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(openSwag))
        ]
        
        for item in barItems {
            item.tintColor = .black
        }
        
        feedController.setToolbarItems(barItems, animated: true)
        feedNavigation.toolbar.isTranslucent = false
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
        feedPresenter.sort = .hot
        
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
    
    @objc func openSwag() {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let hotAction = UIAlertAction(title: "Hot", style: .default, handler: { _ in
            guard self.feedPresenter.sort != .hot else { return }
            self.feedPresenter.sort = .hot
            self.feedController.refresh()
        })
        let newAction = UIAlertAction(title: "New", style: .default, handler: { _ in
            guard self.feedPresenter.sort != .new else { return }
            self.feedPresenter.sort = .new
            self.feedController.refresh()
        })
        let risingAction = UIAlertAction(title: "Rising", style: .default, handler: { _ in
            guard self.feedPresenter.sort != .rising else { return }
            self.feedPresenter.sort = .rising
            self.feedController.refresh()
        })
        let controversialAction = UIAlertAction(title: "Controversial", style: .default, handler: { _ in
            guard self.feedPresenter.sort != .controversial else { return }
            self.feedPresenter.sort = .controversial
            self.feedController.refresh()
        })
        let topAction = UIAlertAction(title: "Top", style: .default, handler: { _ in
            guard self.feedPresenter.sort != .top else { return }
            self.feedPresenter.sort = .top
            self.feedController.refresh()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            actionController.dismiss(animated: true, completion: nil)
        })
        
        actionController.addAction(hotAction)
        actionController.addAction(newAction)
        actionController.addAction(risingAction)
        actionController.addAction(controversialAction)
        actionController.addAction(topAction)
        actionController.addAction(cancelAction)
    
        feedController.present(actionController, animated: true, completion: nil)
    }
    
    @objc func openSwagger() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { _ in
            let controller = MediaViewController()
            
            let barItemClose = UIBarButtonItem(title: "Close", style: .plain, target: controller, action: #selector(controller.close))
            controller.navigationItem.leftBarButtonItem = barItemClose
            controller.navigationItem.title = "Media"
            
            let navigationController = ASNavigationController(rootViewController: controller)
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.tintColor = .black
            
            let presenter = MediaPresenter(feedPresenter: self.feedPresenter)
            controller.delegate = presenter
            
            self.feedNavigation.present(navigationController, animated: true, completion: nil)
        })
    }
}

extension Main: FeedPresenterDelegate {
    func didTapViewDiscussion(listing: Listing, model: FeedViewModel) {
        let discussionPresenter = ListingDiscussionPresenter(listingId: listing.id, subreddit: listing.subreddit, sort: .top, feedViewModel: model)
        let discussionController = FeedDetailViewController()
        discussionController.delegate = discussionPresenter
        feedNavigation.pushViewController(discussionController, animated: true)
    }
    
    func didTapFlashMessage(listing: Listing) {
        let albumPresenter = AlbumPresenter(url: listing.url)
        let albumController = AlbumViewController()
        albumController.delegate = albumPresenter
        feedNavigation.pushViewController(albumController, animated: true)
    }
    
    func didDisappear() {
        feedNavigation.isToolbarHidden = true
        slideMenuController.disableSwipe()
    }
    
    func didAppear() {
        slideMenuController.enableSwipe()
        feedNavigation.isToolbarHidden = false
        feedNavigation.isNavigationBarHidden = false
    }
}
