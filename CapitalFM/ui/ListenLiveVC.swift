//
//  ListenLiveVC.swift
//  CapitalFM
//
//  Created by mac on 04/10/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import AVKit
import MBProgressHUD

class ListenLiveVC: UIViewController {
    
    @IBOutlet weak var ivLive: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var ivGif: UIImageView!
    
    var isPlaying: Bool!
    var player: AVPlayer!
    var loader: MBProgressHUD!
    var dateUtil = DateUtil()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setShowImage()
        
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
        player = AVPlayer(url: URL(string: MyConstants().URL_LIVE_STREAM)!)
        player.volume = 1.0
    }
    
    func startPlayer(){
        loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //        player.rate = 1.0
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
                presenterName = ""
                showName = ""
                imageName = ""
            case 500..<600:
                imageName = ""
            case 600..<1000:
                imageName = ""
            case 1000..<1400:
                imageName = ""
            case 1400..<1500:
                imageName = ""
            case 1500..<1900:
                imageName = ""
            case 1900..<2200:
                imageName = ""
            case 2200..<2400:
                imageName = ""
            default:
                imageName = ""
            }
        case "thu":
            switch timeInt {
            case 0..<100:
                imageName = ""
            case 500..<600:
                imageName = ""
            case 600..<1000:
                imageName = ""
            case 1000..<1400:
                imageName = ""
            case 1400..<1500:
                imageName = ""
            case 1500..<1900:
                imageName = ""
            case 1900..<2200:
                imageName = ""
            case 2200..<2300:
                imageName = ""
            case 2300..<2400:
                imageName = ""
            default:
                imageName = ""
            }
        case "fri":
            switch timeInt {
            case 0..<100:
                imageName = ""
            case 500..<600:
                imageName = ""
            case 600..<1000:
                imageName = ""
            case 1000..<1400:
                imageName = ""
            case 1400..<1500:
                imageName = ""
            case 1500..<1900:
                imageName = ""
            case 1900..<2100:
                imageName = ""
            case 2100..<2300:
                imageName = ""
            case 2300..<2400:
                imageName = ""
            default:
                imageName = ""
            }
        case "sat":
            switch timeInt {
            case 0..<200:
                imageName = ""
            case 500..<700:
                imageName = ""
            case 700..<1000:
                imageName = ""
            case 1000..<1400:
                imageName = ""
            case 1400..<1700:
                imageName = ""
            case 1700..<1900:
                imageName = ""
            case 1900..<2100:
                imageName = ""
            case 2100..<2300:
                imageName = ""
            case 2300..<2400:
                imageName = ""
            default:
                imageName = ""
            }
        case "sun":
            switch timeInt {
            case 600..<800:
                imageName = ""
            case 800..<900:
                imageName = ""
            case 900..<1100:
                imageName = ""
            case 1100..<1300:
                imageName = ""
            case 1300..<1500:
                imageName = ""
            case 1500..<1700:
                imageName = ""
            case 1700..<1900:
                imageName = ""
            case 1900..<2200:
                imageName = ""
            case 2200..<2300:
                imageName = ""
            default:
                imageName = ""
            }
        default:
            imageName = ""
        }
    }
}
