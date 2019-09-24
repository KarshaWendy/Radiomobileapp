//
//  HomeVC.swift
//  CapitalFM
//
//  Created by mac on 13/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import ImageSlideshow
import AVKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var carousel: ImageSlideshow!
    @IBOutlet weak var collStories: UICollectionView!
    @IBOutlet weak var viewListen: UIView!
    @IBOutlet weak var ivListen: UIImageView!
    @IBOutlet weak var viewMixes: UIView!
    
    var isPlaying: Bool!
    var player: AVPlayer!
    
    let localSourceAds = [BundleImageSource(imageString: "images"), BundleImageSource(imageString: "images-2"), BundleImageSource(imageString: "3")]
    
    let storyImages = [UIImage(named: "news3"), UIImage(named: "news2"), UIImage(named: "news1")]
    
    override func viewWillAppear(_ animated: Bool) {
        carousel.unpauseTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Capital FM"
        
        viewListen.backgroundColor = UIColor.MyTheme.primaryColor
        viewMixes.backgroundColor = UIColor.MyTheme.accentColor
        
        isPlaying = false

        setUpSlider()
        
        let tapListen = UITapGestureRecognizer(target: self, action: #selector(HomeVC.tappedListen))
        
        viewListen.addGestureRecognizer(tapListen)
        
        let tapMixes = UITapGestureRecognizer(target: self, action: #selector(HomeVC.tappedMixes))
        
        viewMixes.addGestureRecognizer(tapMixes)
        // Do any additional setup after loading the view.
    }
    
    func setUpSlider(){
        carousel.contentScaleMode = UIViewContentMode.scaleAspectFill
        carousel.slideshowInterval = 4.0
        //carousel.pageControlPosition = PageControlPosition.hidden
        carousel.draggingEnabled = true
        carousel.setImageInputs(localSourceAds)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryCell
        cell.tvSummary.text = MyConstants().dummyText
        cell.iv.image = storyImages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iphoneHeight = 100
        let ipadHeight = 140
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            return CGSize(width: collStories.bounds.size.width - 4, height: CGFloat(iphoneHeight))
        } else {
            return CGSize(width: (collStories.bounds.size.width/2)-4, height: CGFloat(ipadHeight))
        }
    }
    
    @objc func tappedListen(sender : UITapGestureRecognizer)
    {
        if isPlaying{
            stopPlayer()
        } else {
            startPlayer()
        }
    }
    
    @objc func tappedMixes(sender : UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "segueMixes", sender: self)
    }
    
    func startPlayer(){
        if player == nil {
            player = AVPlayer(url: URL(string: MyConstants().URL_LIVE_STREAM)!)
            player.volume = 1.0
            player.rate = 1.0
        }
        
        player.play()
//        if player.error != nil && player.rate != 0 {
//            print("AAAA")
//        } else {
//            print("BBB")
//        }
        ivListen.image = nil
        ivListen.image = UIImage(imageLiteralResourceName: "ic_pause")
        isPlaying = true
    }
    
    func stopPlayer() -> Void {
        player.pause()
        ivListen.image = UIImage(imageLiteralResourceName: "ic_play")
        isPlaying = false
    }
}
