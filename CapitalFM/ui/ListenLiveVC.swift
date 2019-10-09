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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivLive.image = UIImage(named: "live12")
        
        setUpPlayer()
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        if isPlaying{
            stopPlayer()
            ivGif.image = UIImage(named: "EwnNL")
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
}
