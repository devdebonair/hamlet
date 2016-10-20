//
//  ViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 9/29/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit
import PINRemoteImage

protocol FeedControllerDelegate {
    func dataSource() -> [FeedViewModel]
    func didLoad()
    func didReachEnd()
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    enum CellType: Int {
        case media = 0
        case flash = 1
        case action = 2
        case upvotes = 3
        case description = 4
        case submission = 5
        case blank = 6
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        tv.estimatedRowHeight = 250
        tv.estimatedSectionHeaderHeight = 25
        tv.rowHeight = UITableViewAutomaticDimension
        tv.sectionHeaderHeight = UITableViewAutomaticDimension
        tv.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.IDENTIFIER)
        tv.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.IDENTIFIER)
        tv.register(ActionTableViewCell.self, forCellReuseIdentifier: ActionTableViewCell.IDENTIFIER)
        tv.register(AsyncVideoTableViewCell.self, forCellReuseIdentifier: AsyncVideoTableViewCell.IDENTIFIER)
        tv.register(BlankTableViewCell.self, forCellReuseIdentifier: BlankTableViewCell.IDENTIFIER)
        tv.register(FlashTableViewCell.self, forCellReuseIdentifier: FlashTableViewCell.IDENTIFIER)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.IDENTIFIER)
        return tv
    }()
    
    var delegate: FeedControllerDelegate!
    var dataSource: [FeedViewModel] {
        return delegate.dataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(20)
        }
        
        delegate.didLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let feedItem = dataSource[section]
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = feedItem.title
        label.numberOfLines = 0
        label.textColor = .darkText
        
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.99)
        
        if let _ = feedItem.media {
            container.addBorder(edges: .bottom, colour: UIColor.lightGray.withAlphaComponent(0.5), thickness: 0.4)
        }
        
        container.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(container).inset(15)
        }
        
        return container
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = dataSource[indexPath.section]
        var identifier: String
        
        switch indexPath.row {
        case CellType.media.rawValue:
            identifier = feedItem.media?.type == .video ? AsyncVideoTableViewCell.IDENTIFIER : PhotoTableViewCell.IDENTIFIER
            if feedItem.media == nil && Imgur.isImgurUrl(url: feedItem.linkUrl) { identifier = PhotoTableViewCell.IDENTIFIER }
            else if feedItem.media == nil { identifier = LabelTableViewCell.IDENTIFIER }
        case CellType.flash.rawValue:
            identifier = feedItem.flashMessage == nil ? BlankTableViewCell.IDENTIFIER : FlashTableViewCell.IDENTIFIER
        case CellType.action.rawValue:
            identifier = ActionTableViewCell.IDENTIFIER
        case CellType.upvotes.rawValue:
            identifier = LabelTableViewCell.IDENTIFIER
        case CellType.description.rawValue:
            identifier = LabelTableViewCell.IDENTIFIER
        case CellType.submission.rawValue:
            identifier = LabelTableViewCell.IDENTIFIER
        case CellType.blank.rawValue:
            identifier = BlankTableViewCell.IDENTIFIER
        default:
            identifier = UITableViewCell.IDENTIFIER
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        cell.preservesSuperviewLayoutMargins = false
        cell.selectionStyle = .none
        
        if let cell = cell as? PhotoTableViewCell, let media = feedItem.media, indexPath.row == CellType.media.rawValue {
            let mediaSize = CGSize(width: media.width, height: media.height)
            let height = aspectHeight(tableView.frame.size, mediaSize)
            cell.imagePhoto.pin_setImage(from: media.url)
            cell.setPhotoHeight(height)
        }
        
        if let cell = cell as? AsyncVideoTableViewCell, let media = feedItem.media, media.type == .video {
            let mediaSize = CGSize(width: media.width, height: media.height)
            let height = aspectHeight(tableView.frame.size, mediaSize)
            cell.setMediaHeight(height: height)
            cell.setVideoUrl(url: media.url)
            cell.videoPlayer.url = media.poster
        }
        
        if let cell = cell as? FlashTableViewCell, let message = feedItem.flashMessage, let color = feedItem.flashColor {
            cell.message = message.uppercased()
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            cell.labelMessage.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold)
            cell.colorProgress = .clear
            cell.contentView.superview?.backgroundColor = .clear
            cell.labelMessage.textColor = color

            let imageView = UIImageView(image: #imageLiteral(resourceName: "disclose"))
            imageView.frame.size = CGSize(width: 13, height: 13)
            imageView.contentMode = .scaleAspectFit
            cell.accessoryView = imageView
            cell.accessoryView?.tintColor = cell.labelMessage.textColor
            cell.accessoryView?.backgroundColor = .clear
        }
        
        if let cell = cell as? ActionTableViewCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            cell.tintColor = feedItem.actionColor
        }
        
        if let cell = cell as? LabelTableViewCell, indexPath.row == CellType.upvotes.rawValue {
            let attachment = NSTextAttachment()
            attachment.image = #imageLiteral(resourceName: "arrow-up-filled")
            attachment.bounds.size = CGSize(width: 11, height: 11)
            let attachmentString = NSAttributedString(attachment: attachment)
            let string = NSMutableAttributedString(attributedString: attachmentString)
            string.append(NSAttributedString(string: " \(feedItem.upvotes) upvotes"))
            cell.labelContent.textColor = .darkText
            cell.labelContent.attributedText = feedItem.upvotes > 0 ? string : nil
            cell.labelContent.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        }
        
        if let cell = cell as? LabelTableViewCell, (indexPath.row == CellType.description.rawValue || indexPath.row == CellType.media.rawValue) {
            if indexPath.row == CellType.description.rawValue && feedItem.media == nil {
                cell.labelContent.text = nil
                cell.labelContent.attributedText = nil
            } else {
                cell.labelContent.font = UIFont.systemFont(ofSize: 12)
                let authorString = NSAttributedString(string: feedItem.author, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: cell.labelContent.font.pointSize, weight: UIFontWeightSemibold)])
                let string = NSMutableAttributedString(attributedString: authorString)
                string.append(NSAttributedString(string: " \(feedItem.description)"))
                cell.labelContent.attributedText = feedItem.description.isEmpty ? nil : string
            }
        }
        
        if let cell = cell as? LabelTableViewCell, indexPath.row == CellType.submission.rawValue {
            cell.labelContent.textColor = UIColor(red: 164/255, green: 164/255, blue: 164/255, alpha: 1.0)
            cell.labelContent.font = UIFont.systemFont(ofSize: 12.0)
            cell.labelContent.attributedText = NSAttributedString(string: feedItem.submission)
        }
        
        if let cell = cell as? BlankTableViewCell {
            if indexPath.row == CellType.blank.rawValue {
                cell.setHeight(height: 15)
            } else {
                cell.setHeight(height: 0)
            }
        }
        
        if indexPath.section == dataSource.count - 1 && indexPath.row == 0 {
            delegate.didReachEnd()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PhotoTableViewCell {
            cell.imagePhoto.pin_cancelImageDownload()
        }
        
        if let cell = cell as? AsyncVideoTableViewCell, cell.videoPlayer.isPlaying() {
            cell.videoPlayer.pause()
            cell.videoPlayer.url = nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let feedItem = dataSource[indexPath.section]
        if let cell = cell as? AsyncVideoTableViewCell, let media = feedItem.media, media.type == .video {
            cell.videoPlayer.play()
        }
        
        if let cell = cell as? FlashTableViewCell, feedItem.flashMessage != nil, let color = feedItem.flashColor {
            UIView.animate(withDuration: 0.25, delay: 2.0, options: [], animations: {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                cell.contentView.superview?.backgroundColor = color
                }, completion: { _ in
                    cell.accessoryView?.tintColor = .white
                    cell.labelMessage.textColor = .white
            })
        }
    }
    
    private func playVisibleVideoCells(willPlay: Bool = true) {
        let cells = tableView.visibleCells
        for cell in cells {
            if let cell = cell as? AsyncVideoTableViewCell {
                if willPlay {
                    if !cell.videoPlayer.isPlaying() {
                        cell.videoPlayer.play()
                    }
                } else {
                    if cell.videoPlayer.isPlaying() {
                        cell.videoPlayer.pause()
                    }
                }
            }
        }
    }

}
