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
    @IBOutlet weak var bar: UIProgressView!
    @IBOutlet weak var btnPlay: UIButton!
    
    var mix : Mix!
    var player : AVPlayer!
    var isPlaying = false
    var appUtil = AppUtil()
    var loader: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Play Music"
        
        tvTitle.text = mix.title
        tvDuration.text = DateUtil().formatDuration(duration: mix.duration)
        
        if !mix.artwork_url.isEmpty{
            let url = URL(string: mix.artwork_url)
            iv.kf.setImage(with: url)
        }
        
        let streamUrl = mix.stream_url + "?client_id=" + MyConstants().SOUNDCLOUD_CLIENT_ID
        player = AVPlayer(url: URL(string: streamUrl)!)
        player.volume = 1.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        if isPlaying {
            player.pause()
            isPlaying = false
            btnPlay.setImage(UIImage(imageLiteralResourceName: "ic_play_black"), for: .normal)
        } else {
            if mix.stream_url.isEmpty{
                appUtil.showAlert(title: "", msg: "Cannot stream this track")
                return
            }
            
            loader = MBProgressHUD.showAdded(to: self.view, animated: true)
            player.play()
            player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            isPlaying = true
            btnPlay.setImage(UIImage(imageLiteralResourceName: "ic_pause_black"), for: .normal)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{
            loader.hide(animated: true)
        }
    }

}
