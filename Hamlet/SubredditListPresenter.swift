//
//  SubredditListPresenter.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol SubredditListPresenterDelegate {
    func didSelectSubreddit(id: String)
    func didBeginSearch()
    func didEndSearch()
}

class SubredditListPresenter: SubredditListDelegate {
    
    var delegate: SubredditListPresenterDelegate!
    
    var originList = [
        SubredditListViewModel(title: "Anime", subtitle: "anime", imageURL: URL(string: "http://avatarfiles.alphacoders.com/473/47330.png"), primaryKey: "anime"),
        SubredditListViewModel(title: "Anime GIFS", subtitle: "animegifs", imageURL: URL(string: "http://i.imgur.com/DCHiBtLs.gif"), primaryKey: "animegifs"),
        SubredditListViewModel(title: "Anna Faith", subtitle: "anna_faith", imageURL: URL(string: "https://lh4.googleusercontent.com/-o0_9tHdEKVs/AAAAAAAAAAI/AAAAAAAAAKE/AAwrSgy-ig8/photo.jpg"), primaryKey: "anna_faith"),
        SubredditListViewModel(title: "Anna Kendrick", subtitle: "annakendrick", imageURL: URL(string: "https://pbs.twimg.com/profile_images/784237083158249472/k3Dnlclw.jpg"), primaryKey: "annakendrick"),
        SubredditListViewModel(title: "Art of Sucking", subtitle: "artofsucking", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png"), primaryKey: "artofsucking"),
        SubredditListViewModel(title: "Ass", subtitle: "ass", imageURL: URL(string: "http://lh4.googleusercontent.com/-W9lL2fa73u4/AAAAAAAAAAI/AAAAAAAAABk/5_EoivsQAA4/photo.jpg"), primaryKey: "ass"),
        SubredditListViewModel(title: "Battlefield One", subtitle: "battlefield_one", imageURL: URL(string: "https://pbs.twimg.com/profile_images/728687810543132673/rJJHEYs2.jpg"), primaryKey: "battlefield_one"),
        SubredditListViewModel(title: "Boku No Hero Academia", subtitle: "bokunoheroacademia", imageURL: URL(string: "http://orig08.deviantart.net/dd60/f/2015/067/3/0/boku_no_hero_academia_by_wilmer29-d8kzxvf.png"), primaryKey: "bokunoheroacademia"),
        SubredditListViewModel(title: "Busty Petite", subtitle: "bustypetite", imageURL: URL(string: "http://i.imgur.com/oL66Tigs.jpg"), primaryKey: "bustypetite"),
        SubredditListViewModel(title: "Crunchyroll", subtitle: "crunchyroll", imageURL: URL(string: "http://apkdl.in/apkimage/_nkEa-2GgZID4Lk319No6VBpCvFUcQiXDYGTdBea9GmbuVZQKLHFud3y88SV60IbDrjc"), primaryKey: "crunchyroll"),
        SubredditListViewModel(title: "Dillion Harper", subtitle: "dillion_harper", imageURL: URL(string: "http://images-cdn.9gag.com/photo/aYwzrQV_700b.jpg"), primaryKey: "dillion_harper"),
        SubredditListViewModel(title: "Do It Yourself", subtitle: "diy", imageURL: URL(string: "http://alphazxts.org/wp-content/uploads/2016/08/home-decor-ideas-diy-qkekv2zf.jpg"), primaryKey: "diy"),
        SubredditListViewModel(title: "Doujinshi", subtitle: "doujinshi", imageURL: URL(string: "http://i0.kym-cdn.com/photos/images/newsfeed/000/039/611/HRtittymonster.png"), primaryKey: "doujinshi"),
        SubredditListViewModel(title: "Earth Porn", subtitle: "earthporn", imageURL: URL(string: "http://vignette2.wikia.nocookie.net/deadspace/images/7/7d/DS3_Erf.png/revision/latest?cb=20130217174526"), primaryKey: "earthporn"),
        SubredditListViewModel(title: "Ecchi", subtitle: "ecchi", imageURL: URL(string: "https://pbs.twimg.com/profile_images/727765153085849603/P9D-3RIi.jpg"), primaryKey: "ecchi"),
        SubredditListViewModel(title: "Extra Mile", subtitle: "extramile", imageURL: URL(string: "http://i.imgur.com/8rVKKhes.jpg"), primaryKey: "extramile"),
        SubredditListViewModel(title: "Fallout 4", subtitle: "fo4", imageURL: URL(string: "https://s-media-cache-ak0.pinimg.com/564x/d9/cc/48/d9cc48ed2453f72a4afab7b16dddd709.jpg"), primaryKey: "fo4"),
        SubredditListViewModel(title: "Futanari", subtitle: "futanari", imageURL: URL(string: "http://i.imgur.com/dHDXNTKs.jpg"), primaryKey: "futanari"),
        SubredditListViewModel(title: "Girls Finishing the Job", subtitle: "girlsfinishingthejob", imageURL: URL(string: "https://pbs.twimg.com/profile_images/495673163707973632/EL6iB3XR.jpeg"), primaryKey: "girlsfinishingthejob"),
        SubredditListViewModel(title: "GW Couples", subtitle: "gwcouples", imageURL: URL(string: "https://pbs.twimg.com/profile_images/706936815706464256/MHA-nPqN.jpg"), primaryKey: "gwcouples"),
        SubredditListViewModel(title: "Helga Lovekaty", subtitle: "helgalovekaty", imageURL: URL(string: "https://lh3.googleusercontent.com/-GXVMfOgRaZY/AAAAAAAAAAI/AAAAAAAAAgg/yRGhSbpQKJA/photo.jpg"), primaryKey: "helgalovekaty"),
        SubredditListViewModel(title: "Hentai", subtitle: "hentai", imageURL: URL(string: "http://i.imgur.com/Ahr6nnA.png"), primaryKey: "hentai"),
        SubredditListViewModel(title: "Hentai GIF", subtitle: "hentai_gif", imageURL: URL(string: "http://i.imgur.com/DudWKRSs.gif"), primaryKey: "hentai_gif"),
        SubredditListViewModel(title: "Hot For Fitness", subtitle: "hotforfitness", imageURL: URL(string: "https://s-media-cache-ak0.pinimg.com/564x/7d/6f/0c/7d6f0c659bd21a6a933f414e80b59af2.jpg"), primaryKey: "hotforfitness"),
        SubredditListViewModel(title: "Huge Dick Tiny Chick", subtitle: "hugedicktinychick", imageURL: URL(string: "https://c1.staticflickr.com/1/167/422865740_1e58afc9cd_b.jpg"), primaryKey: "hugedicktinychick"),
        SubredditListViewModel(title: "Instagram Hotties", subtitle: "instagramhotties", imageURL: URL(string: "https://4.bp.blogspot.com/-Xxqtrl7jObQ/Vs20ppQr5YI/AAAAAAAADoo/xIFyjyY9qQQ/s1600/Ekaterina%2BUsmanova%2B2.jpg"), primaryKey: "instagramhotties"),
        SubredditListViewModel(title: "Keijo!!!!", subtitle: "keijo", imageURL: URL(string: "https://pbs.twimg.com/profile_images/732536169628459008/fwrz1pxb.jpg"), primaryKey: "keijo"),
        SubredditListViewModel(title: "Kennedy Leigh", subtitle: "kennedyleigh", imageURL: URL(string: "https://lh5.googleusercontent.com/-uuIGtD_wttQ/AAAAAAAAAAI/AAAAAAAAABY/2RKwhE0PPfE/photo.jpg"), primaryKey: "kennedyleigh"),
        SubredditListViewModel(title: "Lips That Grip", subtitle: "lipsthatgrip", imageURL: URL(string: "https://lh4.googleusercontent.com/-xj0nr143z-A/AAAAAAAAAAI/AAAAAAAAAS0/E7mxSB3y7zo/photo.jpg"), primaryKey: "lipsthatgrip"),
        SubredditListViewModel(title: "Margot Robbie", subtitle: "margotrobbie", imageURL: URL(string: "http://www.hubimagery.com/wp-content/uploads/2016/05/PA-28235512.jpg"), primaryKey: "margotrobbie"),
        SubredditListViewModel(title: "Naruto", subtitle: "naruto", imageURL: URL(string: "https://pbs.twimg.com/profile_images/618646854054473728/j8W-C5qO.jpg"), primaryKey: "naruto"),
        SubredditListViewModel(title: "No Man's Sky The Game", subtitle: "nomansskythegame", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/6/67/No_Man's_Sky.jpg"), primaryKey: "nomansskythegame"),
        SubredditListViewModel(title: "NSFW GIF", subtitle: "nsfw_gif", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png"), primaryKey: "nsfw_gif"),
        SubredditListViewModel(title: "NSFW GIFS", subtitle: "nsfw_gifs", imageURL: URL(string: "http://i.imgur.com/ULF1tbWs.jpg"), primaryKey: "nsfw_gifs"),
        SubredditListViewModel(title: "One True Rem", subtitle: "onetruerem", imageURL: URL(string: "http://files.gamebanana.com/img/ico/sprays/576bf3599100f.png"), primaryKey: "onetruerem"),
        SubredditListViewModel(title: "Photoshop Battles", subtitle: "photoshopbattles", imageURL: URL(string: "http://icons.iconarchive.com/icons/hamzasaleem/adobe-cc/256/Photoshop-icon.png"), primaryKey: "photoshopbattles"),
        SubredditListViewModel(title: "Pokemon", subtitle: "pokemon", imageURL: URL(string: "http://www.educationalappstore.com/images/upload/10521-logo-pokemon-go.jpg"), primaryKey: "pokemon"),
        SubredditListViewModel(title: "Politics", subtitle: "politics", imageURL: URL(string: "https://pbs.twimg.com/profile_images/750300510264107008/G8-PA5KA.jpg"), primaryKey: "politics"),
        SubredditListViewModel(title: "Porn In Fifteen Seconds", subtitle: "porninfifteenseconds", imageURL: URL(string: "http://i.imgur.com/3SdBXens.gif"), primaryKey: "porninfifteenseconds"),
        SubredditListViewModel(title: "Playstation 4", subtitle: "ps4", imageURL: URL(string: "http://image.flaticon.com/icons/png/128/34/34221.png"), primaryKey: "ps4"),
        SubredditListViewModel(title: "ReZero", subtitle: "re_zero", imageURL: URL(string: "http://orig04.deviantart.net/c89c/f/2016/084/c/4/rezero_kara_hajimeru_isekai_seikatsu_anime_icon_by_wasir525-d9whg8t.png"), primaryKey: "re_zero"),
        SubredditListViewModel(title: "Rocket League", subtitle: "rocketleague", imageURL: URL(string: "https://store.playstation.com/store/api/chihiro/00_09_000/container/US/en/999/UP2002-CUSA01163_00-SFTHEME000000001/1475628000000/image?_version=00_09_000&platform=chihiro&w=225&h=225&bg_color=000000&opacity=100"), primaryKey: "rocketleague"),
        SubredditListViewModel(title: "Sexy Tummies", subtitle: "sexytummies", imageURL: URL(string: "https://pbs.twimg.com/media/COJi7tsUcAAlK4-.jpg"), primaryKey: "sexytummies"),
        SubredditListViewModel(title: "Skyrim", subtitle: "skyrim", imageURL: URL(string: "https://65.media.tumblr.com/avatar_5d7f6264baaf_128.png"), primaryKey: "skyrim"),
        SubredditListViewModel(title: "The Walking Dead", subtitle: "thewalkingdead", imageURL: URL(string: "https://images-na.ssl-images-amazon.com/images/I/81IkbRlAXQL.png"), primaryKey: "thewalkingdead"),
        SubredditListViewModel(title: "Wincest Texts", subtitle: "wincesttexts", imageURL: URL(string: "https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iOS/iphone6-ios9-messages-imessage-text.jpg"), primaryKey: "wincesttexts"),
        SubredditListViewModel(title: "XBOX ONE", subtitle: "xboxone", imageURL: URL(string: "http://absolutexbox.com/wp-content/uploads/2016/04/cropped-xbox-logo-640x386.jpg"), primaryKey: "xboxone")
    ]
    
    var list = [SubredditListViewModel]()
    
    init() {
        delegate = self
    }
    
    func didTapSearch() {
        delegate.didBeginSearch()
    }
    
    func didSelectItem(tableNode: ASTableNode, row: Int) {
        let item = dataSource()[row]
        delegate.didSelectSubreddit(id: item.primaryKey)
        if !list.isEmpty {
            didCancelSearch(tableNode: tableNode)
        }
    }
    
    func didSearch(tableNode: ASTableNode, text: String) {
        let weakSelf = self
        Subreddit.search(query: text, sort: .popular) { (subreddits) in
            let viewModels = subreddits.map({ (subreddit: Subreddit) -> SubredditListViewModel in
                return SubredditListViewModel(
                    title: subreddit.url.replacingOccurrences(of: "/r/", with: "").replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "/", with: "").capitalized,
                    subtitle: "\(subreddit.numberOfSubscribers.commaFormat) subscribers • \(subreddit.title.htmlDecodedString)",
                    imageURL: subreddit.headerImageUrl,
                    primaryKey: subreddit.url.replacingOccurrences(of: "/r/", with: "").replacingOccurrences(of: "/", with: ""))
            })
            weakSelf.list = viewModels
            tableNode.reloadData()
        }
    }
    
    func didCancelSearch(tableNode: ASTableNode) {
        searchClear()
        delegate.didEndSearch()
        tableNode.reloadData()
    }
    
    func searchClear() {
        list = []
    }
    
    func dataSource() -> [SubredditListViewModel] { return list.isEmpty ? originList : list }
    func didLoad(tableNode: ASTableNode) {}
}

extension SubredditListPresenter: SubredditListPresenterDelegate {
    func didSelectSubreddit(id: String) {}
    func didBeginSearch() {}
    func didEndSearch() {}
}
