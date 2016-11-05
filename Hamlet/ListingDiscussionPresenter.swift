//
//  ListingDiscussionPresenter.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ListingDiscussionPresenter {

    let sort: Comment.Sort
    let listingId: String
    let subreddit: String
    let feedViewModel: FeedViewModel
    
    var commentNodes = [FeedDetailViewModel]()
    var flatCommentMap = [Int: [FeedDetailCommentViewModel]]()
    
    init(listingId: String, subreddit: String, sort: Comment.Sort, feedViewModel: FeedViewModel) {
        self.listingId = listingId
        self.sort = sort
        self.subreddit = subreddit
        self.feedViewModel = feedViewModel
    }
    
    func mapCommentNodes(comment: Comment, section: Int) -> TreeNode<FeedDetailCommentViewModel> {
        let item = FeedDetailCommentViewModel(body: comment.body, metaInformation: "\(comment.author) • \(comment.dateCreated.timeAgo(numericDates: true)) • \(comment.ups) upvotes", primaryKey: comment.id)
        let node = TreeNode<FeedDetailCommentViewModel>(value: item)
        if var arr = flatCommentMap[section] {
            arr.append(item)
            flatCommentMap[section] = arr
        }
        for reply in comment.replies {
            node.addChild(mapCommentNodes(comment: reply, section: section))
        }
        return node
    }
}

extension ListingDiscussionPresenter: FeedDetailViewControllerDelegate {
    func feedItemSubject() -> FeedViewModel { return feedViewModel }
    func dataSource() -> [FeedDetailViewModel] { return commentNodes }
    func numberOfRootComments() -> Int { return commentNodes.count }
    func numberOfCommentsIn(parent: FeedDetailViewModel) -> Int { return parent.comment.count }
    func parentCommentAt(section: Int) -> FeedDetailViewModel { return commentNodes[section] }
    
    func commentAt(parent: FeedDetailViewModel, section: Int, index: Int) -> FeedDetailCommentViewModel {
        guard let child = getChildNode(parent: parent, section: section, index: index) else {
            return FeedDetailCommentViewModel(body: "", metaInformation: "", primaryKey: "")
        }
        return child.value
    }
    
    func numberOfParents(parent: FeedDetailViewModel, section: Int, index: Int) -> Int {
        guard let child = getChildNode(parent: parent, section: section, index: index) else { return 0 }
        return child.numberOfParents
    }
    
    func didLoad(tableNode: ASTableNode) {
        let weakSelf = self
        Comment.fetch(from: listingId, subreddit: subreddit, sort: .top) { (comments) in
            if !comments.isEmpty {
                for index in 0..<comments.count {
                    weakSelf.flatCommentMap[index] = []
                    let comment = comments[index]
                    let item = FeedDetailViewModel(comment: weakSelf.mapCommentNodes(comment: comment, section: index))
                    weakSelf.commentNodes.append(item)
                }
                tableNode.insertSections(IndexSet(integersIn: 1...comments.count), with: .fade)
            }
        }
    }
    
    private func getChildNode(parent: FeedDetailViewModel, section: Int, index: Int) -> TreeNode<FeedDetailCommentViewModel>? {
        guard let array = flatCommentMap[section], let child = parent.comment.search(array[index]) else { return nil }
        return child
    }
}
