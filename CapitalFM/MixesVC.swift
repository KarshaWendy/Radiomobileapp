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
import MBProgressHUD

class MixesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collView: UICollectionView!
    var player : AVPlayer!
    var mixes = [Mix]()
    var appUtil = AppUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "DJ Mixes"
        
        fetchMixes()
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mixes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MixCell
        cell.tvTitle.text = mixes[indexPath.row].title
        
        cell.btnPlay.tag = indexPath.row
        cell.btnDownload.tag = indexPath.row
        
        if mixes[indexPath.row].streamable == true {
            cell.btnPlay.addTarget(self, action: #selector(self.tappedPlay(sender:)), for: .touchUpInside)
        } else {
            cell.btnPlay.isHidden = true
        }
        
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
        let streamUrl = mixes[sender.tag].stream_url + "?client_id=" + MyConstants().SOUNDCLOUD_CLIENT_ID
//        player = AVPlayer(url: URL(string: "https://api.soundcloud.com/tracks/685412626/stream?client_id=62d04bb9b214abbc31cae1334a28e8ed")!)
        player = AVPlayer(url: URL(string: streamUrl)!)
        player.volume = 1.0
        player.rate = 1.0
        player.play()
        
//        sender.imageView?.image = UIImage(imageLiteralResourceName: "ic_pause_black")
    }
    
    @objc func tappedDownload(sender : UIButton){
        
        
    }
    
    func fetchMixes(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.label.text = "loading..."
        
        Alamofire.request(MyConstants().URL_FETCH_MIXES).responseJSON { response in
        switch response.result {
            
        case .success(let res):
            let mixesJson = JSON(res)
            
//            print(mixesJson)
            
            for i in 1 ..< mixesJson.count{
                let downloadable = mixesJson[i]["downloadable"].bool ?? false
                let created_at = mixesJson[i]["created_at"].string ?? ""
                let title = mixesJson[i]["title"].string ?? ""
                let duration = mixesJson[i]["duration"].string ?? ""
                let artwork_url = mixesJson[i]["artwork_url"].string ?? ""
                let streamable = mixesJson[i]["streamable"].bool ?? false
                let download_url = mixesJson[i]["download_url"].string ?? ""
                let uri = mixesJson[i]["uri"].string ?? ""
                let stream_url = mixesJson[i]["stream_url"].string ?? ""
                
//                self.mixes.append(Mix(downloadable: downloadable, created_at: created_at, title: title, duration: duration, artwork_url: artwork_url, streamable: streamable, download_url: download_url, uri: uri, stream_url: stream_url))
                self.mixes.append(Mix(downloadable: downloadable, created_at: created_at, title: title, duration: duration, artwork_url: artwork_url, streamable: streamable, download_url: download_url, uri: uri, stream_url: stream_url))
            }
            
            DispatchQueue.main.async{
                loader.hide(animated: true)
                self.collView.reloadData()
            }
            
            
//            for i in mixesJson {
//                let downloadable = i
//                let created_at: String
//                let title: String
//                let duration: String
//                let artwork_url: String
//                let streamable: Bool
//                let download_url: String
//                let uri: String
//                let stream_url: String
//            }
            
            break
        case .failure(let error):
            
            DispatchQueue.main.async{
                loader.hide(animated: true)
                if error.localizedDescription.contains("The Internet connection appears to be offline"){
                    self.appUtil.showAlert(title: "Error", msg: MyConstants().CONN_MSG)
                } else {
                    self.appUtil.showAlert(title: "Error", msg: MyConstants().ERR_MSG)
                }
            }
            
            
//            DispatchQueue.main.async(dispatch_get_main_queue(), execute: {
//                MBProgressHUD.hideHUDForView(self.view, animated: true)
//                appUtil.showAlert("Error", userMessageTitle: MyConstants().CONN_MSG)
//            })
            }
        }
        
        
    }
}
