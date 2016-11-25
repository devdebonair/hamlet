//
//  FeedViewModel.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/5/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

struct FeedViewModel {
    enum MediaType: Int {
        case photo = 0
        case video = 1
        case none = 2
    }
    let title: String
    let description: String
    let flashMessage: String?
    let flashColor: UIColor?
    let author: String
    let subreddit: String
    let domain: String
    var media: Media?
    let actionColor: UIColor
    let submission: String
    let linkUrl: URL?
    let primaryKey: String
    let upvotes: Int
}

extension FeedViewModel {
    
    enum CellType: Int {
        case title = 0
        case photo = 1
        case flash = 2
        case action = 3
        case upvotes = 4
        case description = 5
        case submission = 6
        case blank = 7
        case separator = 8
        case mediaDescription = 9
        case video = 10
    }
    
    func getNodeTypeOrder() -> [CellType] {
        var types = [CellType]()
        types.append(.title)
        
        if let media = self.media {
            switch media.type {
            case .photo:
                types.append(.photo)
            case .video:
                types.append(.video)
            }
        } else if self.description.characters.count > 0 {
            types.append(.mediaDescription)
        }
        
        if self.flashColor != nil || self.flashMessage != nil { types.append(.flash) }
        types.append(.action)
        types.append(.separator)
        if self.upvotes > 0 { types.append(.upvotes) }
        
        if self.description.characters.count > 0 && !types.contains(.mediaDescription) { types.append(.description) }
        
        if !self.submission.isEmpty { types.append(.submission) }
        types.append(.blank)
        return types
    }
    
    func getNode(indexPath: IndexPath) -> ASCellNode {
        switch getNodeTypeOrder()[indexPath.row] {
            
        case .title:
            let attributeString = NSAttributedString(
                string: title.htmlDecodedString,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                    NSForegroundColorAttributeName: UIColor.darkText
                ])
            let cell = CellNodeText(attributedString: attributeString, insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            cell.text.maximumNumberOfLines = 0
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case .photo:
            if let media = media, media.type == .photo {
                let cell = CellNodePhoto(url: media.url, size: CGSize(width: media.width, height: media.height))
                cell.selectionStyle = .none
                return cell
            } else { return CellNodeBlank() }
            
        case .video:
            if let media = media, media.type == .video {
                let cell = CellNodeVideo(url: nil, placeholderURL: media.poster, size: CGSize(width: media.width, height: media.height))
                cell.selectionStyle = .none
                return cell
            } else { return CellNodeBlank() }
            
        case .mediaDescription:
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2.0
            
            let string = NSAttributedString(
                string: description.htmlDecodedString,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular),
                    NSParagraphStyleAttributeName: paragraphStyle
                ])
            
            let cell = CellNodeText(attributedString: string, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
            cell.text.maximumNumberOfLines = 8
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case .flash:
            if let message = flashMessage, let color = flashColor {
                let cell = CellNodeFlashMessage(message: message, color: color)
                cell.selectionStyle = .none
                return cell
            }
            else { return CellNodeBlank() }
            
        case .action:
            let cell = CellNodeFeedAction(color: .darkText)
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case .upvotes:
            let attachment = NSTextAttachment()
            attachment.image = #imageLiteral(resourceName: "arrow-up-filled")
            attachment.bounds.size = CGSize(width: 11, height: 11)
            
            let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: " "))
            
            let imageAttribute = NSAttributedString(attachment: attachment)
            let upvoteAttribute = NSMutableAttributedString(
                string: " \(upvotes) upvotes",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)])
            
            attributedString.append(imageAttribute)
            attributedString.append(upvoteAttribute)
            
            let text: NSMutableAttributedString? = upvotes > 0 ? attributedString : nil
            let cell = CellNodeText(attributedString: text, insets: UIEdgeInsets(top: 10, left: 15, bottom: 5, right: 15))
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case .description:
            let authorString = NSAttributedString(
                string: author,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
                ])
            
            let descriptionString = NSAttributedString(
                string: " \(self.description.htmlDecodedString)",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
                ])
            
            let description = NSMutableAttributedString(attributedString: authorString)
            description.append(descriptionString)
            
            let cell = CellNodeText(attributedString: description)
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case .submission:
            let cell = CellNodeText(attributedString: NSAttributedString(string: submission, attributes: [
                NSForegroundColorAttributeName: UIColor(red: 164, green: 164, blue: 164),
                NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]))
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case .blank:
            let cell = CellNodeBlank(height: 15)
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            return cell
            
        case .separator:
            let color = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1.0)
            let inset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            let cell = CellNodeSeparator(color: color, insets: inset)
            cell.selectionStyle = .none
            return cell
        }
    }
}
