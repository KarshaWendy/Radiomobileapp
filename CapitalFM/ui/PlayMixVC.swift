//
//  PlayMixVC.swift
//  CapitalFM
//
//  Created by mac on 25/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import AVKit
import Kingfisher
import MBProgressHUD

class PlayMixVC: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvCount: UILabel!
    @IBOutlet weak var tvDuration: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var bottomBar: UIView!
    
    var mixes = [Mix]()
//    var mix : Mix!
    var position = 0
    var player : AVPlayer!
    var timeObserverToken : Any!
    var isPlaying = false
    var appUtil = AppUtil()
    var loader: MBProgressHUD!
    let notification = NotificationCenter.default
    let KEY_OBSERVER = "currentItem.loadedTimeRanges"
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Play Music"
        self.navigationController?.navigationBar.barTintColor = UIColor.MyTheme.primaryColor
        
        bottomBar.layer.cornerRadius = 16
        
        notification.addObserver(self, selector: #selector(self.cancelBgPlay), name: Notification.Name("StopMix"), object: nil)
        setUpPlayer()
        setUpSlider()
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        if isPlaying {
            pausePlayer()
        } else {
            startPlayer()
        }
    }
    
    @IBAction func btnStop(_ sender: Any) {
        stopPlayer()
    }
    
    @IBAction func btnNext(_ sender: Any) {
        stopPlayer()
        
        if position >= mixes.count {
            position = 0
        } else {
            position+=1
        }
        
        setUpPlayer()
    }
    
    @IBAction func btnPrevious(_ sender: Any) {
        stopPlayer()
        
        if position == 0 {
            position = mixes.count - 1
        } else {
            position-=1
        }
        
        setUpPlayer()
    }
    
    func startPlayer(){
        notification.post(name: Notification.Name("StopLive"), object: nil)
        loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if player == nil {
            setUpPlayer()
            return
        }
        
        if #available(iOS 10.0, *) {
            player?.playImmediately(atRate: 1.0)
        } else {
            player?.play()
        }
        isPlaying = true
        btnPlay.setImage(UIImage(imageLiteralResourceName: "ic_pause"), for: .normal)
    }
    
    func pausePlayer() -> Void {
        player.pause()
        isPlaying = false
        btnPlay.setImage(UIImage(imageLiteralResourceName: "ic_play"), for: .normal)
    }
    
    func stopPlayer() -> Void {
        player.removeObserver(self, forKeyPath: KEY_OBSERVER)
        player.removeTimeObserver(timeObserverToken!)
        
        self.tvCount.text = "00:00"
        self.slider.value = 0
        
        player = nil
        isPlaying = false
        btnPlay.setImage(UIImage(imageLiteralResourceName: "ic_play"), for: .normal)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == KEY_OBSERVER {
            loader.hide(animated: true)
        }
    }

    func setUpPlayer(){
        
        loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let streamUrl = mixes[position].stream_url + "?client_id=" + MyConstants().SOUNDCLOUD_CLIENT_ID
        
        if !mixes[position].artwork_url.isEmpty{
            let url = URL(string: mixes[position].artwork_url)
            iv.kf.setImage(with: url)
        }
        
        tvTitle.text = mixes[position].title
        tvDuration.text = DateUtil().formatDuration(duration: mixes[position].duration)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            AppUtil().showAlert(title: "", msg: "playback error")
        }
        
        player = AVPlayer(url: URL(string: streamUrl)!)
        player.volume = 1.0
        
        if #available(iOS 10.0, *) {
            player?.playImmediately(atRate: 1.0)
        } else {
            player?.play()
        }
        
        player.addObserver(self, forKeyPath: KEY_OBSERVER, options: .new, context: nil)
        let interval = CMTime(value: 1, timescale: 2)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: {(progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            let minsString = String(format: "%02d", Int(seconds) / 60)
            let hrsString = String(format: "%02d", Int(seconds) / (60 * 60))
            
            self.tvCount.text = "\(hrsString):\(minsString):\(secondsString)"
            
            if let duration = self.player.currentItem?.duration {
                let secs = CMTimeGetSeconds(duration)
                self.slider.value = Float(seconds/secs)
            }
        })
        
        
        isPlaying = true
        
        btnPlay.setImage(UIImage(imageLiteralResourceName: "ic_pause"), for: .normal)
    }
    
    @objc func cancelBgPlay(){
        if player != nil {
            stopPlayer()
        }
    }
    
    func setUpSlider(){
        slider.setThumbImage(UIImage(named: "ic_slider"), for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    
    @objc func handleSliderChange(){
        if let duration = player.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(slider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player.seek(to: seekTime, completionHandler: {(completedSeek) in
                
            })
        }
    }
}
