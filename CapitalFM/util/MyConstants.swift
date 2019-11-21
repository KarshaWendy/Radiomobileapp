//
//  MyConstants.swift
//  CapitalFM
//
//  Created by mac on 18/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import Foundation
class MyConstants {
    let PHONE_TYPE_IOS = "iphone"
    
    
    let URL_LIVE_STREAM = "https://icecast2.getstreamhosting.com:8050/stream.mp3"
    
    //feed
    let URL_FEED_NEWS = "https://www.capitalfm.co.ke/news/wp-json/wp/v2/posts"
    let URL_FEED_SAUCE = "https://www.capitalfm.co.ke/thesauce/wp-json/wp/v2/posts"
    let URL_FEED_LIFESTYLE = "https://www.capitalfm.co.ke/lifestyle/wp-json/wp/v2/posts"
    
    //souncloud
    let SOUNDCLOUD_CLIENT_ID = "62d04bb9b214abbc31cae1334a28e8ed"
    let SOUNDCLOUD_CLIENT_SECRET = "50d544ec31928cf35e1a1567e06deac4"
    let URL_FETCH_MIXES = "https://api.soundcloud.com/users/27162382/tracks?client_id=62d04bb9b214abbc31cae1334a28e8ed"
    
    //app apis
    let BASE_URL = "https://data.smartapplicationsgroup.com/capitalfm/api/"
    let KEY_AUTH = "Authorization:Bearer"
    
    //Google
    let GOOGLE_CLIENT_ID = "828926963122-piau0tthhriltebacd0f41176c21dr77.apps.googleusercontent.com"
    
    let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
    
    let ERR_MSG = "A problem occurred, try again later"
    let CONN_MSG = "Ensure you are connected to the internet"
    
    //shows
    let QUIET_STORM = "The Quiet Storm"
    let CAPITAL_MORNING = "Capital in the Morning"
    let FUSE = "The Fuse"
    let RADIO_ACTIVE = "Radio Active"
    let JAM = "The Jam"
    let HITS = "Hits"
    let HEARTBEAT = "Heartbeat"
    let TED_TALK = "Ted Talk Radio"
    let TED_TALK_RPT = "Ted Talk Radio (RPT)"
    let INFUSED = "Infused"
    let SATURDAY_BREAKFAST = "Saturday Breakfast"
    let RICK_DEES = "Rick Dees"
    let MUSIC_SPORT = "Sat Music & Sport"
    let CYPHER = "The Cypher"
    let WORLD_GROOVE = "World Groove"
    let WHEELZ_STEEL = "Wheelz of Steel"
    let CLUB_CAPITAL = "Club Capital"
    let HEAT = "The Heat"
    let DANCE_REPUBLIC = "Dance Republic"
    let LEGENDS = "The Legends Show"
    let COUNTRY_ROAD = "Country Road"
    let LOUNGE = "The Lounge"
    let FOOTBALL_SUNDAY = "Football Sunday"
    let SOUND = "The Sound"
    let SOUL_GROOVE = "Soul Groove"
    let ONE_LOVE = "One Love"
    let CAPITAL_JAZZ_CLUB = "Capital Jazz Club"
    
    //schedule
    let SHOWS : [Show] = [
        Show(showName: "The Quiet Storm", showDay: "MON - FRI", startTime: "05:00", endTime: "06:00", showLogo: "logo_quiet_storm"),
        Show(showName: "Capital in the Morning", showDay: "MON - FRI", startTime: "06:00", endTime: "10:00", showLogo: "logo_capital_in_the_morning"),
        Show(showName: "The Fuse", showDay: "MON - FRI", startTime: "10:00", endTime: "14:00", showLogo: "logo_the_fuse"),
        Show(showName: "Radio Active", showDay: "MON - FRI", startTime: "14:00", endTime: "15:00", showLogo: "logo_radio_active"),
        Show(showName: "The Jam", showDay: "MON - FRI", startTime: "15:00", endTime: "19:00", showLogo: "logo_the_jam"),
        Show(showName: "Hits", showDay: "MON - FRI", startTime: "19:00", endTime: "22:00", showLogo: "logo_hits"),
        Show(showName: "Heartbeat", showDay: "MON - FRI", startTime: "22:00", endTime: "01:00", showLogo: "logo_heartbeat"),
        Show(showName: "Ted Talk Radio", showDay: "THU", startTime: "22:00", endTime: "23:00", showLogo: "logo_ted_talk"),
        Show(showName: "Heartbeat", showDay: "THU", startTime: "23:00", endTime: "01:00", showLogo: "logo_heartbeat"),
        Show(showName: "The Heat", showDay: "FRI", startTime: "19:00", endTime: "21:00", showLogo: "icon_placeholder"),
        Show(showName: "Dance Republic", showDay: "FRI", startTime: "21:00", endTime: "23:00", showLogo: "icon_placeholder"),
        Show(showName: "Club Capital", showDay: "FRI", startTime: "23:00", endTime: "02:00", showLogo: "icon_placeholder"),
        Show(showName: "Infused", showDay: "SAT", startTime: "05:00", endTime: "07:00", showLogo: "logo_dance_republic"),
        Show(showName: "Saturday Breakfast", showDay: "SAT", startTime: "07:00", endTime: "10:00", showLogo: "logo_sat_breakfast"),
        Show(showName: "Rick Dees", showDay: "SAT", startTime: "10:00", endTime: "14:00", showLogo: "logo_rick_dees"),
        Show(showName: "Sat Music & Sport", showDay: "SAT", startTime: "14:00", endTime: "17:00", showLogo: "logo_sat_music_sports"),
        Show(showName: "The Cypher", showDay: "SAT", startTime: "17:00", endTime: "19:00", showLogo: "logo_the_cypher"),
        Show(showName: "World Groove", showDay: "SAT", startTime: "19:00", endTime: "21:00", showLogo: "logo_world_groove"),
        Show(showName: "Wheelz of Steel", showDay: "SAT", startTime: "21:00", endTime: "23:00", showLogo: "logo_wheels_of_steel"),
        Show(showName: "Club Capital", showDay: "SAT", startTime: "23:00", endTime: "02:00", showLogo: "icon_placeholder"),
        Show(showName: "The Legends Show", showDay: "SUN", startTime: "06:00", endTime: "08:00", showLogo: "icon_placeholder"),
        Show(showName: "Country Road", showDay: "SUN", startTime: "08:00", endTime: "09:00", showLogo: "logo_country_road"),
        Show(showName: "The Lounge", showDay: "SUN", startTime: "09:00", endTime: "11:00", showLogo: "logo_lounge"),
        Show(showName: "Football Sunday", showDay: "SUN", startTime: "11:00", endTime: "13:00", showLogo: "logo_football_sunday"),
        Show(showName: "The Sound", showDay: "SUN", startTime: "13:00", endTime: "15:00", showLogo: "logo_the_sound"),
        Show(showName: "Soul Groove", showDay: "SUN", startTime: "15:00", endTime: "17:00", showLogo: "icon_placeholder"),
        Show(showName: "One Love", showDay: "SUN", startTime: "17:00", endTime: "19:00", showLogo: "logo_one_love"),
        Show(showName: "Capital Jazz Club", showDay: "SUN", startTime: "19:00", endTime: "22:00", showLogo: "logo_capital_jazz"),
        Show(showName: "Ted Talk Radio (Rpt)", showDay: "SUN", startTime: "22:00", endTime: "23:00", showLogo: "logo_ted_talk")
    ]
    
    func loginUrl() -> String {
        return BASE_URL + "login"
    }
    
    func registerUrl() -> String {
        return BASE_URL + "register"
    }
    
    func registerSocialUrl() -> String {
        return BASE_URL + "register_social"
    }
    
    func startListeningUrl() -> String {
        return BASE_URL + "startlistening"
    }
    
    func stopListeningUrl() -> String {
        return BASE_URL + "stoplistening"
    }
}
