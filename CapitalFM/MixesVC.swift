//
//  MixesVC.swift
//  CapitalFM
//
//  Created by mac on 20/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import SwiftyJSON

class MixesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collView: UICollectionView!
    var player : AVPlayer!
    var mixes: [Mix]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "DJ Mixes"
        
        fetchMixes()
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MixCell
        cell.tvTitle.text = "DJ Capital fm Mixx"
        
        cell.btnPlay.tag = indexPath.row
        cell.btnDownload.tag = indexPath.row
        
        cell.btnPlay.addTarget(self, action: #selector(self.tappedPlay(sender:)), for: .touchUpInside)
        
        cell.btnDownload.addTarget(self, action: #selector(self.tappedDownload(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let myHeight = 80
        let ipadHeight = 120
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            return CGSize(width: collView.bounds.size.width - 4, height: CGFloat(myHeight))
        } else {
            return CGSize(width: (collView.bounds.size.width/2)-4, height: CGFloat(ipadHeight))
        }
    }
    
    @objc func tappedPlay(sender : UIButton){
        print("--------")
        player = AVPlayer(url: URL(string: "https://icecast2.getstreamhosting.com:8050/stream.mp3")!)
        player.volume = 1.0
        player.rate = 1.0
        
        player.play()
        
//        sender.imageView?.image = UIImage(imageLiteralResourceName: "ic_pause_black")
    }
    
    @objc func tappedDownload(sender : UIButton){
        
        
    }
    
    func fetchMixes(){
        Alamofire.request("https://api.soundcloud.com/tracks?client_id=62d04bb9b214abbc31cae1334a28e8ed").responseJSON { response in
            print(response)
        }
        
        
    }
}
