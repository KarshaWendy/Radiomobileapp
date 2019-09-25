//
//  PlayMixVC.swift
//  CapitalFM
//
//  Created by mac on 25/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import Kingfisher

class PlayMixVC: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvCount: UILabel!
    @IBOutlet weak var tvDuration: UILabel!
    @IBOutlet weak var bar: UIProgressView!
    @IBOutlet weak var btnPlay: UIButton!
    
    var mix : Mix!
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Play Music"
        
        tvTitle.text = mix.title
        tvDuration.text = DateUtil().formatDuration(duration: mix.duration)
        
        if !mix.artwork_url.isEmpty{
            let url = URL(string: mix.artwork_url)
            iv.kf.setImage(with: url)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
