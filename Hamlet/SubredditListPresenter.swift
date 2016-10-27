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

class SubredditListPresenter: SubredditListDelegate {
    
    let list = [
        SubredditListViewModel(name: "Anime", imageURL: URL(string: "http://avatarfiles.alphacoders.com/473/47330.png")),
        SubredditListViewModel(name: "Anime GIFS", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(name: "Anna Faith", imageURL: URL(string: "https://lh4.googleusercontent.com/-o0_9tHdEKVs/AAAAAAAAAAI/AAAAAAAAAKE/AAwrSgy-ig8/photo.jpg")),
        SubredditListViewModel(name: "Anna Kendrick", imageURL: URL(string: "https://pbs.twimg.com/profile_images/784237083158249472/k3Dnlclw.jpg")),
        SubredditListViewModel(name: "Art of Sucking", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(name: "Ass", imageURL: URL(string: "http://lh4.googleusercontent.com/-W9lL2fa73u4/AAAAAAAAAAI/AAAAAAAAABk/5_EoivsQAA4/photo.jpg")),
        SubredditListViewModel(name: "Battlefield One", imageURL: URL(string: "https://pbs.twimg.com/profile_images/728687810543132673/rJJHEYs2.jpg")),
        SubredditListViewModel(name: "Boku No Hero Academia", imageURL: URL(string: "http://orig08.deviantart.net/dd60/f/2015/067/3/0/boku_no_hero_academia_by_wilmer29-d8kzxvf.png")),
        SubredditListViewModel(name: "Busty Petite", imageURL: URL(string: "http://i.imgur.com/oL66Tigs.jpg")),
        SubredditListViewModel(name: "Crunchyroll", imageURL: URL(string: "http://apkdl.in/apkimage/_nkEa-2GgZID4Lk319No6VBpCvFUcQiXDYGTdBea9GmbuVZQKLHFud3y88SV60IbDrjc")),
        SubredditListViewModel(name: "Dillion Harper", imageURL: URL(string: "http://images-cdn.9gag.com/photo/aYwzrQV_700b.jpg")),
        SubredditListViewModel(name: "Do It Yourself", imageURL: URL(string: "http://alphazxts.org/wp-content/uploads/2016/08/home-decor-ideas-diy-qkekv2zf.jpg")),
        SubredditListViewModel(name: "Doujinshi", imageURL: URL(string: "http://i0.kym-cdn.com/photos/images/newsfeed/000/039/611/HRtittymonster.png")),
        SubredditListViewModel(name: "Earth Porn", imageURL: URL(string: "http://vignette2.wikia.nocookie.net/deadspace/images/7/7d/DS3_Erf.png/revision/latest?cb=20130217174526")),
        SubredditListViewModel(name: "Ecchi", imageURL: URL(string: "https://pbs.twimg.com/profile_images/727765153085849603/P9D-3RIi.jpg")),
        SubredditListViewModel(name: "Fallout 4", imageURL: URL(string: "https://s-media-cache-ak0.pinimg.com/564x/d9/cc/48/d9cc48ed2453f72a4afab7b16dddd709.jpg")),
        SubredditListViewModel(name: "Futanari", imageURL: URL(string: "http://i.imgur.com/dHDXNTKs.jpg")),
        SubredditListViewModel(name: "Girls Finishing the Job", imageURL: URL(string: "https://pbs.twimg.com/profile_images/495673163707973632/EL6iB3XR.jpeg")),
        SubredditListViewModel(name: "GW Couples", imageURL: URL(string: "https://pbs.twimg.com/profile_images/706936815706464256/MHA-nPqN.jpg")),
        SubredditListViewModel(name: "Helga Lovekaty", imageURL: URL(string: "https://lh3.googleusercontent.com/-GXVMfOgRaZY/AAAAAAAAAAI/AAAAAAAAAgg/yRGhSbpQKJA/photo.jpg")),
        SubredditListViewModel(name: "Hentai", imageURL: URL(string: "http://i.imgur.com/Ahr6nnA.png")),
        SubredditListViewModel(name: "Hentai GIF", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(name: "Hot For Fitness", imageURL: URL(string: "https://s-media-cache-ak0.pinimg.com/564x/7d/6f/0c/7d6f0c659bd21a6a933f414e80b59af2.jpg")),
        SubredditListViewModel(name: "Huge Dick Tiny Chick", imageURL: URL(string: "https://c1.staticflickr.com/1/167/422865740_1e58afc9cd_b.jpg")),
        SubredditListViewModel(name: "Instagram Hotties", imageURL: URL(string: "https://4.bp.blogspot.com/-Xxqtrl7jObQ/Vs20ppQr5YI/AAAAAAAADoo/xIFyjyY9qQQ/s1600/Ekaterina%2BUsmanova%2B2.jpg")),
        SubredditListViewModel(name: "Keijo!!!!", imageURL: URL(string: "https://pbs.twimg.com/profile_images/732536169628459008/fwrz1pxb.jpg")),
        SubredditListViewModel(name: "Kennedy Leigh", imageURL: URL(string: "https://lh5.googleusercontent.com/-uuIGtD_wttQ/AAAAAAAAAAI/AAAAAAAAABY/2RKwhE0PPfE/photo.jpg")),
        SubredditListViewModel(name: "Lips That Grip", imageURL: URL(string: "https://lh4.googleusercontent.com/-xj0nr143z-A/AAAAAAAAAAI/AAAAAAAAAS0/E7mxSB3y7zo/photo.jpg")),
        SubredditListViewModel(name: "Margot Robbie", imageURL: URL(string: "http://www.hubimagery.com/wp-content/uploads/2016/05/PA-28235512.jpg")),
        SubredditListViewModel(name: "Naruto", imageURL: URL(string: "https://pbs.twimg.com/profile_images/618646854054473728/j8W-C5qO.jpg")),
        SubredditListViewModel(name: "No Man's Sky The Game", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/6/67/No_Man's_Sky.jpg")),
        SubredditListViewModel(name: "NSFW GIF", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(name: "NSFW GIFS", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(name: "One True Rem", imageURL: URL(string: "http://files.gamebanana.com/img/ico/sprays/576bf3599100f.png")),
        SubredditListViewModel(name: "Photoshop Battles", imageURL: URL(string: "http://icons.iconarchive.com/icons/hamzasaleem/adobe-cc/256/Photoshop-icon.png")),
        SubredditListViewModel(name: "Pokemon", imageURL: URL(string: "http://www.educationalappstore.com/images/upload/10521-logo-pokemon-go.jpg")),
        SubredditListViewModel(name: "Politics", imageURL: URL(string: "https://pbs.twimg.com/profile_images/750300510264107008/G8-PA5KA.jpg")),
        SubredditListViewModel(name: "Porn In Fifteen Seconds", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(name: "Playstation 4", imageURL: URL(string: "https://pbs.twimg.com/profile_images/747865535778594817/UaToFfWv.jpg")),
        SubredditListViewModel(name: "ReZero", imageURL: URL(string: "http://orig04.deviantart.net/c89c/f/2016/084/c/4/rezero_kara_hajimeru_isekai_seikatsu_anime_icon_by_wasir525-d9whg8t.png")),
        SubredditListViewModel(name: "Rocket League", imageURL: URL(string: "https://store.playstation.com/store/api/chihiro/00_09_000/container/US/en/999/UP2002-CUSA01163_00-SFTHEME000000001/1475628000000/image?_version=00_09_000&platform=chihiro&w=225&h=225&bg_color=000000&opacity=100")),
        SubredditListViewModel(name: "Sexy Tummies", imageURL: URL(string: "https://pbs.twimg.com/media/COJi7tsUcAAlK4-.jpg")),
        SubredditListViewModel(name: "Skyrim", imageURL: URL(string: "https://65.media.tumblr.com/avatar_5d7f6264baaf_128.png")),
        SubredditListViewModel(name: "The Walking Dead", imageURL: URL(string: "https://images-na.ssl-images-amazon.com/images/I/81IkbRlAXQL.png")),
        SubredditListViewModel(name: "Wincest Texts", imageURL: URL(string: "https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iOS/iphone6-ios9-messages-imessage-text.jpg")),
        SubredditListViewModel(name: "XBOX ONE", imageURL: URL(string: "http://absolutexbox.com/wp-content/uploads/2016/04/cropped-xbox-logo-640x386.jpg"))
        ]
    
    let subs = [
        "anime",
        "animegifs",
        "anna_faith",
        "annakendrick",
        "artofsucking",
        "ass",
        "battlefield_one",
        "bokunoheroacademia",
        "bustypetite",
        "crunchyroll",
        "dillion_harper",
        "diy",
        "doujinshi",
        "earthporn",
        "ecchi",
        "fo4",
        "futanari",
        "girlsfinishingthejob",
        "gwcouples",
        "helgalovekaty",
        "hentai",
        "hentai_gif",
        "hotforfitness",
        "hugedicktinychick",
        "instagramhotties",
        "keijo",
        "kennedyleigh",
        "lipsthatgrip",
        "margotrobbie",
        "naruto",
        "nomansskythegame",
        "nsfw_gif",
        "nsfw_gifs",
        "onetruerem",
        "photoshopbattles",
        "pokemon",
        "politics",
        "porninfifteenseconds",
        "ps4",
        "re_zero",
        "rocketleague",
        "sexytummies",
        "skyrim",
        "thewalkingdead",
        "wincesttexts",
        "xboxone"
    ]
    
    var onDidSelectSubreddit: ((_ subId: String, _ model: SubredditListViewModel)->Void)?
    
    init() {}
    
    func didSelectItem(tableNode: ASTableNode, row: Int) {
        if let onDidSelectSubreddit = onDidSelectSubreddit {
            let item = list[row]
            let id = subs[row]
            onDidSelectSubreddit(id, item)
        }
    }
    func dataSource() -> [SubredditListViewModel] { return list }
    func didLoad(tableNode: ASTableNode) {}
}
