//
//  AppDelegate.swift
//  Hamlet
//
//  Created by Vincent Moore on 9/29/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AVFoundation
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let presenter = SubredditListPresenter()
        let controller = SubredditListViewController()
        
        controller.delegate = presenter
        
        let navController = UINavigationController(rootViewController: controller)
        navController.hidesBarsOnSwipe = true
        navController.navigationBar.alpha = 1.0
        controller.navigationItem.title = "Subreddits"
        navController.navigationBar.barTintColor = .white
        navController.navigationBar.tintColor = .darkText
        navController.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)]
        
        presenter.onDidSelectSubreddit = { id in
            
            let presenter = HomePresenter(subredditID: id, sort: .hot)
            let controller = FeedViewController()
            controller.delegate = presenter
            navController.pushViewController(controller, animated: true)
            
            presenter.onDidTapFlashMessage = { (listing: Listing) in
                let albumPresenter = AlbumPresenter(url: listing.url)
                let albumController = AlbumViewController()
                albumController.delegate = albumPresenter
                navController.pushViewController(albumController, animated: true)
            }
            
            presenter.onDidTapViewDiscussion = { (listing: Listing, model: FeedViewModel) in
                let discussionPresenter = ListingDiscussionPresenter(listingId: listing.id, subreddit: listing.subreddit, sort: .top, feedViewModel: model)
                let discussionController = FeedDetailViewController()
                discussionController.delegate = discussionPresenter
                navController.pushViewController(discussionController, animated: true)
                
            }
        }
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            print("Error with audio sessions")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

