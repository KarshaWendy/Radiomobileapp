//
//  ListenLiveVC.swift
//  CapitalFM
//
//  Created by mac on 04/10/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MBProgressHUD

class ListenLiveVC: UIViewController {
    
    @IBOutlet weak var ivLive: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var ivGif: UIImageView!
    @IBOutlet weak var tvShow: UILabel!
    @IBOutlet weak var tvPresenter: UILabel!
    
    var isPlaying: Bool!
    var player: AVPlayer!
    var loader: MBProgressHUD!
    var dateUtil = DateUtil()
    var cons = MyConstants()
    let audioSession = AVAudioSession.sharedInstance()
    let notification = NotificationCenter.default
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setShowImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notification.addObserver(self, selector: #selector(self.cancelBgPlay), name: Notification.Name("StopLive"), object: nil)
        setUpPlayer()
        
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        if isPlaying{
            stopPlayer()
            ivGif.image = UIImage(named: "icon_live_gif")
        } else {
            startPlayer()
            ivGif.loadGif(name: "livegif")
        }
    }
    
    func setUpPlayer(){
        isPlaying = false
        
        do {
            try audioSession.setCategory(.playback)
        } catch {
            AppUtil().showAlert(title: "", msg: "playback error")
        }
        
        notification.post(name: Notification.Name("StopMix"), object: nil)
        
        player = AVPlayer(url: URL(string: MyConstants().URL_LIVE_STREAM)!)
        player.volume = 1.0
    }
    
    func startPlayer(){
        loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //        player.rate = 1.0
    
        notification.post(name: Notification.Name("StopMix"), object: nil)
        
        player.play()
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
//        btnPlay.setBackgroundImage(UIImage(named: "icon_stop"), for: .normal)
        btnPlay.setImage(UIImage(named: "icon_stop"), for: .normal)
        isPlaying = true
    }
    
    func stopPlayer() -> Void {
        player.pause()
        btnPlay.setImage(UIImage(named: "icon_play"), for: .normal)
        isPlaying = false
    }
    
    @objc func cancelBgPlay(){
        if player != nil {
            stopPlayer()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{
            loader.hide(animated: true)
        }
    }
    
    func setShowImage(){
        let now = Date()
        let day = dateUtil.dateToString(theDate: now, outputFormat: "EEE")
        let time = dateUtil.dateToString(theDate: now, outputFormat: "HHmm")
        let timeInt = Int(time)!
        var cat = ""
        var showName = ""
        var presenterName = ""
        var imageName = ""
        let defaultImg = "live12"
        
        switch day {
        case "Mon":
            cat = "weekday"
        case "Tue":
            cat = "weekday"
        case "Wed":
            cat = "weekday"
        case "Thu":
            cat = "thu"
        case "Fri":
            cat = "fri"
        case "Sat":
            cat = "sat"
        case "Sun":
            cat = "sun"
        default:
            cat = "weekday"
        }
        
        switch cat {
        case "weekday":
            switch timeInt {
            case 0..<100:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = defaultImg
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "live1"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "live2"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "live3"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "live6"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "live4"
            case 1900..<2200:
                presenterName = "Mandi & Neville"
                showName = cons.HITS
                imageName = "live5"
            case 2200..<2400:
                presenterName = "Laid back Dj Mixes"
                imageName = cons.HEARTBEAT
                imageName = "live7"
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "thu":
            switch timeInt {
            case 0..<100:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = ""
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "live1"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "live2"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "live3"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "live6"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "live4"
            case 1900..<2200:
                presenterName = ""
                showName = cons.HITS
                imageName = defaultImg
            case 2200..<2300:
                presenterName = ""
                showName = cons.TED_TALK
                imageName = "live19"
            case 2300..<2400:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = defaultImg
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "fri":
            switch timeInt {
            case 0..<100:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = defaultImg
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "live1"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "live2"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "live3"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "live6"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "live4"
            case 1900..<2100:
                presenterName = "Mandi & Neville"
                showName = cons.HEAT
                imageName = defaultImg
            case 2100..<2300:
                presenterName = ""
                showName = cons.DANCE_REPUBLIC
                imageName = defaultImg
            case 2300..<2400:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "sat":
            switch timeInt {
            case 0..<200:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
            case 500..<700:
                presenterName = "Dj Tony"
                showName = cons.INFUSED
                imageName = defaultImg
            case 700..<1000:
                presenterName = "Tracy, Djs Tumz & Lithium"
                showName = cons.SATURDAY_BREAKFAST
                imageName = "live8"
            case 1000..<1400:
                presenterName = "Rick Dees"
                showName = cons.RICK_DEES
                imageName = "live9"
            case 1400..<1700:
                presenterName = "Solo, Wokabi & Alex"
                showName = cons.MUSIC_SPORT
                imageName = "live10"
            case 1700..<1900:
                presenterName = "Dj Slick"
                showName = cons.CYPHER
                imageName = "live11"
            case 1900..<2100:
                presenterName = "Kui Kabala"
                showName = cons.WORLD_GROOVE
                imageName = "live12"
            case 2100..<2300:
                presenterName = "Dj Adrian"
                showName = cons.WHEELZ_STEEL
                imageName = "live13"
            case 2300..<2400:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "sun":
            switch timeInt {
            case 0..<200:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
            case 600..<800:
                presenterName = ""
                showName = cons.LEGENDS
                imageName = defaultImg
            case 800..<900:
                presenterName = ""
                showName = cons.COUNTRY_ROAD
                imageName = defaultImg
            case 900..<1100:
                presenterName = "Chao"
                showName = cons.LOUNGE
                imageName = "live14"
            case 1100..<1300:
                presenterName = "Wokabi & friends"
                showName = cons.FOOTBALL_SUNDAY
                imageName = "live10"
            case 1300..<1500:
                presenterName = "Dj Mo"
                showName = cons.SOUND
                imageName = "live15"
            case 1500..<1700:
                presenterName = "Dj Adrian"
                showName = cons.SOUL_GROOVE
                imageName = "live13"
            case 1700..<1900:
                presenterName = "Ras Luigi"
                showName = cons.ONE_LOVE
                imageName = "live17"
            case 1900..<2200:
                presenterName = "Kaima & Jacob Asiyo"
                showName = cons.CAPITAL_JAZZ_CLUB
                imageName = "live16"
            case 2200..<2300:
                presenterName = ""
                showName = cons.TED_TALK_RPT
                imageName = "live18"
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        default:
            presenterName = ""
            showName = ""
            imageName = defaultImg
        }
        
        ivLive.image = UIImage(named: imageName)
        tvShow.text = showName
        tvPresenter.text = presenterName
    }
    
}
