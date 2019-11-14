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
import Kingfisher

class MixesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collView: UICollectionView!
    
    var player : AVPlayer!
    var mixes = [Mix]()
    var selectedMix : Mix!
    var position = 0
    var appUtil = AppUtil()
    var isPlaying = false
    let notification = NotificationCenter.default
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "DJ Mixes"
        
        notification.addObserver(self, selector: #selector(self.cancelBgPlay), name: Notification.Name("StopMix"), object: nil)
        fetchMixes()
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mixes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MixCell
        cell.tvTitle.text = mixes[indexPath.row].title
        cell.tvDate.text = DateUtil().formatDate(theDate: mixes[indexPath.row].created_at, inputFormat: "yyyy/MM/dd HH:mm:ss Z")
        cell.tvDuration.text = DateUtil().formatDuration(duration: mixes[indexPath.row].duration)
        
//        cell.btnPlay.tag = indexPath.row
//        cell.btnDownload.tag = indexPath.row
//
//        if mixes[indexPath.row].streamable == true {
//            cell.btnPlay.addTarget(self, action: #selector(self.tappedPlay(sender:)), for: .touchUpInside)
//        } else {
//            cell.btnPlay.isHidden = true
//        }
//        cell.btnDownload.addTarget(self, action: #selector(self.tappedDownload(sender:)), for: .touchUpInside)
//        if mixes[indexPath.row].downloadable == true {
//            cell.btnDownload.addTarget(self, action: #selector(self.tappedDownload(sender:)), for: .touchUpInside)
//        } else {
//            cell.btnDownload.isHidden = true
//        }
        if !mixes[indexPath.row].artwork_url.isEmpty{
            let url = URL(string: mixes[indexPath.row].artwork_url)
            cell.iv.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iphoneHeight = 80
        let ipadHeight = 120
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            return CGSize(width: collView.bounds.size.width - 4, height: CGFloat(iphoneHeight))
        } else {
            return CGSize(width: (collView.bounds.size.width/2)-4, height: CGFloat(ipadHeight))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        notification.post(name: Notification.Name("StopLive"), object: nil)
        selectedMix = mixes[indexPath.row]
        position = indexPath.row
        performSegue(withIdentifier: "seguePlay", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? PlayMixVC
//        vc!.mix = selectedMix
        vc!.mixes = mixes
        vc!.position = position
    }
    
//    @objc func tappedPlay(sender : UIButton){
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//
//        let cell = collView.cellForItem(at: indexPath) as! MixCell
//
//        if isPlaying{
//            if player != nil {
//                player.pause()
//            }
//
//            isPlaying = false
//
//            cell.btnPlay.imageView?.image = UIImage(imageLiteralResourceName: "ic_play_black")
//        } else {
//            let streamUrl = mixes[sender.tag].stream_url + "?client_id=" + MyConstants().SOUNDCLOUD_CLIENT_ID
//            //        player = AVPlayer(url: URL(string: "https://api.soundcloud.com/tracks/685412626/stream?client_id=62d04bb9b214abbc31cae1334a28e8ed")!)
//            player = AVPlayer(url: URL(string: streamUrl)!)
//            player.volume = 1.0
//            player.rate = 1.0
//            player.play()
//
//            isPlaying = true
//
//            cell.btnPlay.imageView?.image = UIImage(imageLiteralResourceName: "ic_pause_black")
//
//        }
//
//        collView.reloadItems(at: [indexPath])
//
//    }
//
//    @objc func tappedDownload(sender : UIButton){
//        print("starting")
////        Alamofire.request("https://api.soundcloud.com/tracks/685412359/download?client_id=62d04bb9b214abbc31cae1334a28e8ed").response {
////            response in
////            print(response.data)
////        }
//
//        let url = "https://api.soundcloud.com/tracks/685412359/download?client_id=62d04bb9b214abbc31cae1334a28e8ed"
//
//        let destination = DownloadRequest.suggestedDownloadDestination()
//
////        Alamofire.download(url, to: destination).response { response in // method defaults to `.get`
//////            print(response.request)
////            print("myres")
////            print(response.response)
////            print("my1")
////            print(response.temporaryURL)
////            print("my2")
////            print(response.destinationURL)
////            print("my3")
////            print(response.error)
////        }
//
////        let destination = DownloadRequest.suggestedDownloadDestination(for: .musicDirectory)
//
//
//        Alamofire.download(
//            url,
//            method: .get,
//            parameters: nil,
//            encoding: JSONEncoding.default,
//            headers: nil,
//            to: destination).downloadProgress(closure: { (progress) in
//
//
//                //progress closure
//            }).response(completionHandler: { (DefaultDownloadResponse) in
//                //here you able to access the DefaultDownloadResponse
//                //result closure
////                print(DefaultDownloadResponse)
//                if DefaultDownloadResponse.error != nil {
//                    self.appUtil.showAlert(title: "Error", msg: DefaultDownloadResponse.error!.localizedDescription)
//                } else {
//                    self.appUtil.showAlert(title: "Complete", msg: "Download completed successfully")
//                }
//            })
//
//    }
    
    
    @objc func cancelBgPlay(){
        if player != nil {
            stopPlayer()
        }
    }
    
    func stopPlayer() -> Void {
        player = nil
        isPlaying = false
    }
    
    func fetchMixes(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.label.text = "loading..."
        
        Alamofire.request(MyConstants().URL_FETCH_MIXES).responseJSON { response in
        switch response.result {
            
        case .success(let res):
            let mixesJson = JSON(res)
            
//            print(mixesJson)
            
            for i in 0 ..< mixesJson.count{
                let downloadable = mixesJson[i]["downloadable"].bool ?? false
                let created_at = mixesJson[i]["created_at"].string ?? ""
                let title = mixesJson[i]["title"].string ?? ""
                let duration = mixesJson[i]["duration"].int ?? 0
                let artwork_url = mixesJson[i]["artwork_url"].string ?? ""
                let streamable = mixesJson[i]["streamable"].bool ?? false
                let download_url = mixesJson[i]["download_url"].string ?? ""
                let favoritings_count = mixesJson[i]["favoritings_count"].string ?? ""
                let permalink_url = mixesJson[i]["permalink_url"].string ?? ""
                let stream_url = mixesJson[i]["stream_url"].string ?? ""
                
                self.mixes.append(Mix(downloadable: downloadable, created_at: created_at, title: title, duration: duration, artwork_url: artwork_url, streamable: streamable, download_url: download_url, favoritings_count: favoritings_count, permalink_url: permalink_url, stream_url: stream_url))
            }
            
            DispatchQueue.main.async{
                loader.hide(animated: true)
                self.collView.reloadData()
            }
            
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
            
            }
        }
        
        
    }
}
