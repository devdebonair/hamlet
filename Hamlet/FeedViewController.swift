//
//  ViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 9/29/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum CellType: Int {
        case media = 0
        case action = 1
        case description = 2
        case submission = 3
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        tv.estimatedRowHeight = 220
        tv.estimatedSectionHeaderHeight = 50
        tv.rowHeight = UITableViewAutomaticDimension
        tv.sectionHeaderHeight = UITableViewAutomaticDimension
        tv.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.IDENTIFIER)
        tv.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.IDENTIFIER)
        tv.register(ActionTableViewCell.self, forCellReuseIdentifier: ActionTableViewCell.IDENTIFIER)
        tv.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.IDENTIFIER)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.IDENTIFIER)
        return tv
    }()
    
    var listings = [Listing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(20)
        }
        
        Subreddit.fetchHotListing(subreddit: "porninfifteenseconds") { (listings) in
            self.listings = listings
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let listing = listings[section]
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = listing.title
        label.numberOfLines = 0
        label.textColor = .darkText
        
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.99)
        
        if listing.previewImage != nil {
            container.addBorder(edges: .bottom, colour: UIColor.lightGray.withAlphaComponent(0.5), thickness: 0.4)
        }
        
        container.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(container).inset(15)
        }
        
        return container
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = listings[indexPath.section]
        var identifier: String
        
        switch indexPath.row {
        case CellType.media.rawValue:
            identifier = listing.isVideo ? VideoTableViewCell.IDENTIFIER : PhotoTableViewCell.IDENTIFIER
        case CellType.action.rawValue:
            identifier = ActionTableViewCell.IDENTIFIER
        case CellType.description.rawValue:
            identifier = LabelTableViewCell.IDENTIFIER
        case CellType.submission.rawValue:
            identifier = LabelTableViewCell.IDENTIFIER
        default:
            identifier = UITableViewCell.IDENTIFIER
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        cell.preservesSuperviewLayoutMargins = false
        
        if let cell = cell as? PhotoTableViewCell, let preview = listing.previewImage, indexPath.row == CellType.media.rawValue {
            if let domain = listing.domain, domain == Listing.Domain.imgur.rawValue {
                cell.imagePhoto.kf.setImage(with: listing.url)
            } else {
                cell.imagePhoto.kf.setImage(with: preview.source.url)
            }
            
            let height = aspectHeight(tableView.frame.size, CGSize(width: preview.source.width, height: preview.source.height))
            cell.setPhotoHeight(height)
            cell.separatorInset = .zero
        }
        
        if let cell = cell as? VideoTableViewCell, let preview = listing.previewImage, listing.isVideo, let domain = listing.domain, let url = listing.url {
            
            let height = aspectHeight(tableView.frame.size, CGSize(width: preview.source.width, height: preview.source.height))
            cell.setMediaHeight(height)
            cell.separatorInset = .zero
            cell.posterImage.kf.setImage(with: url)
            cell.onReadyToPlay = {
                cell.videoPlayer.play()
            }
            
            switch domain {
            case Listing.Domain.imgur.rawValue:
                print(Imgur.replaceGIFV(url: url)?.absoluteString)
                cell.videoPlayer.url = Imgur.replaceGIFV(url: url)?.absoluteString
            case Listing.Domain.gfycat.rawValue:
                Gfycat.fetch(url: url, completion: { (gfycat) in
                    if let gfycat = gfycat {
                        cell.videoPlayer.url = gfycat.urlMP4?.absoluteString
                    }
                })
            default:
                cell.videoPlayer.url = ""
            }
        }
        
        if indexPath.row == CellType.action.rawValue {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        
        if let cell = cell as? LabelTableViewCell, let description = listing.description?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "#", with: ""), indexPath.row == CellType.description.rawValue {
            cell.labelContent.text = description
        }
        
        if let cell = cell as? LabelTableViewCell, let author = listing.author, let subreddit = listing.subreddit, indexPath.row == CellType.submission.rawValue {
            cell.labelContent.text = "Submitted 1 hour ago by \(author) on r/\(subreddit)"
            let rgbValue: CGFloat = 164/255
            cell.labelContent.textColor = UIColor(red: rgbValue, green: rgbValue, blue: rgbValue, alpha: 1.0)
            cell.labelContent.font = UIFont.systemFont(ofSize: 12.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PhotoTableViewCell {
            cell.imagePhoto.kf.cancelDownloadTask()
        }
        if let cell = cell as? VideoTableViewCell {
            cell.videoPlayer.clean()
        }
    }

}

