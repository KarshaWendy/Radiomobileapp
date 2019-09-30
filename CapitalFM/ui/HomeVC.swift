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
import MBProgressHUD

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var carousel: ImageSlideshow!
    @IBOutlet weak var collStories: UICollectionView!
    @IBOutlet weak var viewListen: UIView!
    @IBOutlet weak var ivListen: UIImageView!
    @IBOutlet weak var viewMixes: UIView!
    
    var isPlaying: Bool!
    var player: AVPlayer!
    var loader: MBProgressHUD!
    
    let localSourceAds = [BundleImageSource(imageString: "radio4"), BundleImageSource(imageString: "radio3"), BundleImageSource(imageString: "radio2"), BundleImageSource(imageString: "radio1")]
    
    let storyImages = [UIImage(named: "news3"), UIImage(named: "news2"), UIImage(named: "news1")]
    
    override func viewWillAppear(_ animated: Bool) {
        carousel.unpauseTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Capital FM"
        self.navigationController?.navigationBar.barTintColor = UIColor.MyTheme.primaryColor
        
        viewListen.backgroundColor = UIColor.MyTheme.primaryColor
        viewMixes.backgroundColor = UIColor.MyTheme.accentColor
        
        isPlaying = false

        setUpSlider()
        setUpPlayer()
        
        let tapListen = UITapGestureRecognizer(target: self, action: #selector(HomeVC.tappedListen))
        
        viewListen.addGestureRecognizer(tapListen)
        
        let tapMixes = UITapGestureRecognizer(target: self, action: #selector(HomeVC.tappedMixes))
        
        viewMixes.addGestureRecognizer(tapMixes)
        
    }
    
    func setUpSlider(){
        carousel.contentScaleMode = UIViewContentMode.scaleToFill
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
    
    func setUpPlayer(){
        player = AVPlayer(url: URL(string: MyConstants().URL_LIVE_STREAM)!)
        player.volume = 1.0
    }
    
    func startPlayer(){
        loader = MBProgressHUD.showAdded(to: viewListen, animated: true)
        
//        player.rate = 1.0
        player.play()
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        ivListen.image = UIImage(imageLiteralResourceName: "ic_pause")
        isPlaying = true
    }
    
    func stopPlayer() -> Void {
        player.pause()
        ivListen.image = UIImage(imageLiteralResourceName: "ic_play")
        isPlaying = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{
            loader.hide(animated: true)
        }
    }
}
