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
        SubredditListViewModel(displayName: "Anime", name: "anime", imageURL: URL(string: "http://avatarfiles.alphacoders.com/473/47330.png")),
        SubredditListViewModel(displayName: "Anime GIFS", name: "animegifs", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(displayName: "Anna Faith", name: "anna_faith", imageURL: URL(string: "https://lh4.googleusercontent.com/-o0_9tHdEKVs/AAAAAAAAAAI/AAAAAAAAAKE/AAwrSgy-ig8/photo.jpg")),
        SubredditListViewModel(displayName: "Anna Kendrick", name: "annakendrick", imageURL: URL(string: "https://pbs.twimg.com/profile_images/784237083158249472/k3Dnlclw.jpg")),
        SubredditListViewModel(displayName: "Art of Sucking", name: "artofsucking", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(displayName: "Ass", name: "ass", imageURL: URL(string: "http://lh4.googleusercontent.com/-W9lL2fa73u4/AAAAAAAAAAI/AAAAAAAAABk/5_EoivsQAA4/photo.jpg")),
        SubredditListViewModel(displayName: "Battlefield One", name: "battlefield_one", imageURL: URL(string: "https://pbs.twimg.com/profile_images/728687810543132673/rJJHEYs2.jpg")),
        SubredditListViewModel(displayName: "Boku No Hero Academia", name: "bokunoheroacademia", imageURL: URL(string: "http://orig08.deviantart.net/dd60/f/2015/067/3/0/boku_no_hero_academia_by_wilmer29-d8kzxvf.png")),
        SubredditListViewModel(displayName: "Busty Petite", name: "bustypetite", imageURL: URL(string: "http://i.imgur.com/oL66Tigs.jpg")),
        SubredditListViewModel(displayName: "Crunchyroll", name: "crunchyroll", imageURL: URL(string: "http://apkdl.in/apkimage/_nkEa-2GgZID4Lk319No6VBpCvFUcQiXDYGTdBea9GmbuVZQKLHFud3y88SV60IbDrjc")),
        SubredditListViewModel(displayName: "Dillion Harper", name: "dillion_harper", imageURL: URL(string: "http://images-cdn.9gag.com/photo/aYwzrQV_700b.jpg")),
        SubredditListViewModel(displayName: "Do It Yourself", name: "diy", imageURL: URL(string: "http://alphazxts.org/wp-content/uploads/2016/08/home-decor-ideas-diy-qkekv2zf.jpg")),
        SubredditListViewModel(displayName: "Doujinshi", name: "doujinshi", imageURL: URL(string: "http://i0.kym-cdn.com/photos/images/newsfeed/000/039/611/HRtittymonster.png")),
        SubredditListViewModel(displayName: "Earth Porn", name: "earthporn", imageURL: URL(string: "http://vignette2.wikia.nocookie.net/deadspace/images/7/7d/DS3_Erf.png/revision/latest?cb=20130217174526")),
        SubredditListViewModel(displayName: "Ecchi", name: "ecchi", imageURL: URL(string: "https://pbs.twimg.com/profile_images/727765153085849603/P9D-3RIi.jpg")),
        SubredditListViewModel(displayName: "Fallout 4", name: "fo4", imageURL: URL(string: "https://s-media-cache-ak0.pinimg.com/564x/d9/cc/48/d9cc48ed2453f72a4afab7b16dddd709.jpg")),
        SubredditListViewModel(displayName: "Futanari", name: "futanari", imageURL: URL(string: "http://i.imgur.com/dHDXNTKs.jpg")),
        SubredditListViewModel(displayName: "Girls Finishing the Job", name: "girlsfinishingthejob", imageURL: URL(string: "https://pbs.twimg.com/profile_images/495673163707973632/EL6iB3XR.jpeg")),
        SubredditListViewModel(displayName: "GW Couples", name: "gwcouples", imageURL: URL(string: "https://pbs.twimg.com/profile_images/706936815706464256/MHA-nPqN.jpg")),
        SubredditListViewModel(displayName: "Helga Lovekaty", name: "helgalovekaty", imageURL: URL(string: "https://lh3.googleusercontent.com/-GXVMfOgRaZY/AAAAAAAAAAI/AAAAAAAAAgg/yRGhSbpQKJA/photo.jpg")),
        SubredditListViewModel(displayName: "Hentai", name: "hentai", imageURL: URL(string: "http://i.imgur.com/Ahr6nnA.png")),
        SubredditListViewModel(displayName: "Hentai GIF", name: "hentai_gif", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(displayName: "Hot For Fitness", name: "hotforfitness", imageURL: URL(string: "https://s-media-cache-ak0.pinimg.com/564x/7d/6f/0c/7d6f0c659bd21a6a933f414e80b59af2.jpg")),
        SubredditListViewModel(displayName: "Huge Dick Tiny Chick", name: "hugedicktinychick", imageURL: URL(string: "https://c1.staticflickr.com/1/167/422865740_1e58afc9cd_b.jpg")),
        SubredditListViewModel(displayName: "Instagram Hotties", name: "instagramhotties", imageURL: URL(string: "https://4.bp.blogspot.com/-Xxqtrl7jObQ/Vs20ppQr5YI/AAAAAAAADoo/xIFyjyY9qQQ/s1600/Ekaterina%2BUsmanova%2B2.jpg")),
        SubredditListViewModel(displayName: "Keijo!!!!", name: "keijo", imageURL: URL(string: "https://pbs.twimg.com/profile_images/732536169628459008/fwrz1pxb.jpg")),
        SubredditListViewModel(displayName: "Kennedy Leigh", name: "kennedyleigh", imageURL: URL(string: "https://lh5.googleusercontent.com/-uuIGtD_wttQ/AAAAAAAAAAI/AAAAAAAAABY/2RKwhE0PPfE/photo.jpg")),
        SubredditListViewModel(displayName: "Lips That Grip", name: "lipsthatgrip", imageURL: URL(string: "https://lh4.googleusercontent.com/-xj0nr143z-A/AAAAAAAAAAI/AAAAAAAAAS0/E7mxSB3y7zo/photo.jpg")),
        SubredditListViewModel(displayName: "Margot Robbie", name: "margotrobbie", imageURL: URL(string: "http://www.hubimagery.com/wp-content/uploads/2016/05/PA-28235512.jpg")),
        SubredditListViewModel(displayName: "Naruto", name: "naruto", imageURL: URL(string: "https://pbs.twimg.com/profile_images/618646854054473728/j8W-C5qO.jpg")),
        SubredditListViewModel(displayName: "No Man's Sky The Game", name: "nomansskythegame", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/6/67/No_Man's_Sky.jpg")),
        SubredditListViewModel(displayName: "NSFW GIF", name: "nsfw_gif", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(displayName: "NSFW GIFS", name: "nsfw_gifs", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(displayName: "One True Rem", name: "onetruerem", imageURL: URL(string: "http://files.gamebanana.com/img/ico/sprays/576bf3599100f.png")),
        SubredditListViewModel(displayName: "Photoshop Battles", name: "photoshopbattles", imageURL: URL(string: "http://icons.iconarchive.com/icons/hamzasaleem/adobe-cc/256/Photoshop-icon.png")),
        SubredditListViewModel(displayName: "Pokemon", name: "pokemon", imageURL: URL(string: "http://www.educationalappstore.com/images/upload/10521-logo-pokemon-go.jpg")),
        SubredditListViewModel(displayName: "Politics", name: "politics", imageURL: URL(string: "https://pbs.twimg.com/profile_images/750300510264107008/G8-PA5KA.jpg")),
        SubredditListViewModel(displayName: "Porn In Fifteen Seconds", name: "porninfifteenseconds", imageURL: URL(string: "http://66.media.tumblr.com/avatar_a96f23c6db9b_128.png")),
        SubredditListViewModel(displayName: "Playstation 4", name: "ps4", imageURL: URL(string: "http://image.flaticon.com/icons/png/128/34/34221.png")),
        SubredditListViewModel(displayName: "ReZero", name: "re_zero", imageURL: URL(string: "http://orig04.deviantart.net/c89c/f/2016/084/c/4/rezero_kara_hajimeru_isekai_seikatsu_anime_icon_by_wasir525-d9whg8t.png")),
        SubredditListViewModel(displayName: "Rocket League", name: "rocketleague", imageURL: URL(string: "https://store.playstation.com/store/api/chihiro/00_09_000/container/US/en/999/UP2002-CUSA01163_00-SFTHEME000000001/1475628000000/image?_version=00_09_000&platform=chihiro&w=225&h=225&bg_color=000000&opacity=100")),
        SubredditListViewModel(displayName: "Sexy Tummies", name: "sexytummies", imageURL: URL(string: "https://pbs.twimg.com/media/COJi7tsUcAAlK4-.jpg")),
        SubredditListViewModel(displayName: "Skyrim", name: "skyrim", imageURL: URL(string: "https://65.media.tumblr.com/avatar_5d7f6264baaf_128.png")),
        SubredditListViewModel(displayName: "The Walking Dead", name: "thewalkingdead", imageURL: URL(string: "https://images-na.ssl-images-amazon.com/images/I/81IkbRlAXQL.png")),
        SubredditListViewModel(displayName: "Wincest Texts", name: "wincesttexts", imageURL: URL(string: "https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iOS/iphone6-ios9-messages-imessage-text.jpg")),
        SubredditListViewModel(displayName: "XBOX ONE", name: "xboxone", imageURL: URL(string: "http://absolutexbox.com/wp-content/uploads/2016/04/cropped-xbox-logo-640x386.jpg"))
    ]
    
    var onDidSelectSubreddit: ((_ subId: String)->Void)?
    
    init() {}
    
    func didSelectItem(tableNode: ASTableNode, row: Int) {
        if let onDidSelectSubreddit = onDidSelectSubreddit {
            let item = list[row]
            onDidSelectSubreddit(item.primaryKey)
        }
    }
    func dataSource() -> [SubredditListViewModel] { return list }
    func didLoad(tableNode: ASTableNode) {}
}
