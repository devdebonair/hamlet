//
//  AlbumPresenter.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/23/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class AlbumPresenter: AlbumViewControllerDelegate {
    
    var albumModels = [AlbumViewModel]()
    
    let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func didLoad(tableNode: ASTableNode) {
        if let id = Imgur.getID(url: url) {
            Imgur.getAlbum(id: id, completion: { (images: [Imgur]) in
                let albumMapping = images.map({ (image) -> AlbumViewModel in
                    var imageURL: URL? = nil
                    var type: Media.MediaType = .photo
                    
                    if let mp4 = image.mp4 {
                        imageURL = mp4
                        type = .video
                    } else if let gif = image.gifv {
                        imageURL = gif
                        type = .photo
                    } else if let link = image.thumbnailHuge {
                        imageURL = link
                        type = .photo
                    }
                    
                    let media = Media(url: imageURL, height: image.height, width: image.width, type: type, poster: nil)
                    return AlbumViewModel(media: media, description: image.description)
                })
                self.albumModels = albumMapping
                tableNode.reloadData()
            })
        }
    }
    
    func dataSource() -> [AlbumViewModel] {
        return albumModels
    }
    
}
