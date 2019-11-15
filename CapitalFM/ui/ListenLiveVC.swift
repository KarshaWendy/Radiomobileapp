//
//  ListenLiveVC.swift
//  CapitalFM
//
//  Created by mac on 04/10/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation

class ListenLiveVC: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var ivShowLogo: UIImageView!
    @IBOutlet weak var ivListenLive: UIImageView!
    @IBOutlet weak var ivLive: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var tvShow: UILabel!
    @IBOutlet weak var tvPresenter: UILabel!
    @IBOutlet weak var tvDay: UILabel!
    @IBOutlet weak var myTabs: UISegmentedControl!
    @IBOutlet weak var collSchedule: UICollectionView!
    
    var isPlaying: Bool!
    var player: AVPlayer!
    var loader: MBProgressHUD!
    var dateUtil = DateUtil()
    let appUtil = AppUtil()
    let sess = SessionManager()
    let cons = MyConstants()
    let audioSession = AVAudioSession.sharedInstance()
    let notification = NotificationCenter.default
    let locationManager = CLLocationManager()
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    var lat = ""
    var lng = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpTabs()
        setShowImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notification.addObserver(self, selector: #selector(self.cancelBgPlay), name: Notification.Name("StopLive"), object: nil)
        setUpPlayer()
    }
    
    func setUpTabs(){
        myTabs.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        myTabs.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        myTabs.tintColor = UIColor.MyTheme.primaryColor
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        if isPlaying{
            stopPlayer()
        } else {
            startPlayer()
        }
    }
    
    func setUpPlayer(){
        isPlaying = false
        
        do {
            try audioSession.setCategory(.playback)
        } catch {
            AppUtil().showAlert(title: "", msg: "playback error")
        }
        
        notification.post(name: Notification.Name("StopMix"), object: nil)
        
        player = AVPlayer(url: URL(string: MyConstants().URL_LIVE_STREAM)!)
        player.volume = 1.0
    }
    
    func startPlayer(){
        loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //        player.rate = 1.0
    
        notification.post(name: Notification.Name("StopMix"), object: nil)
        
        player.play()
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
//        btnPlay.setBackgroundImage(UIImage(named: "icon_stop"), for: .normal)
        btnPlay.setImage(UIImage(named: "icon_stop"), for: .normal)
        isPlaying = true
        
        checkIfLocationIsEnabled()
    }
    
    func stopPlayer() -> Void {
        player.pause()
        btnPlay.setImage(UIImage(named: "icon_play"), for: .normal)
        isPlaying = false
    }
    
    @objc func cancelBgPlay(){
        if player != nil {
            stopPlayer()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{
            loader.hide(animated: true)
        }
    }
    
    func sendStartedListening(){
        let delegate: Alamofire.SessionDelegate = AppUtil.Manager.delegate
        delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = AppUtil.Manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        
        
        
        let startTime = dateUtil.dateToString(theDate: Date(), outputFormat: "ddMMyyyy HHmmss")
        
        let params = ["show_name": "morning show",
                      "phone_type" : cons.PHONE_TYPE_IOS,
                      "phone_identifier": deviceId,
                      "start_time": startTime,
                      "lat": lat,
                      "lng": lng]
        
//        let headers: HTTPHeaders? = nil
        
        
        
        AppUtil.Manager.request(cons.startListeningUrl(), method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: nil).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .success(let res):
                let resJson = JSON(res)
                print(resJson)
                let status = resJson["status"].int ?? 0
                
                
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func sendStoppedListening(){
        let endTime = dateUtil.dateToString(theDate: Date(), outputFormat: "ddMMyyyy HHmmss")
        
        let params = ["listener_token": "",
                      "start_time": endTime]
        
        let headers: HTTPHeaders = ["": ""]
        
        Alamofire.request(cons.stopListeningUrl(), method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: headers).responseJSON(completionHandler: {response in
            
            print(response)
        })
    }
    
    func initLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func checkIfLocationIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            initLocationManager()
            checkLocationPermission()
        } else {
            appUtil.showAlert(title: "", msg: "Allow the app to access your location by turning on your device location")
        }
    }
    
    func checkLocationPermission(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            getLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }
    
    func getLocation(){
        if (locationManager.location?.coordinate) != nil {
            lat = String(describing: locationManager.location!.coordinate.latitude)
            lng = String(describing: locationManager.location!.coordinate.longitude)
        } else {
            lat = "0.0"
            lng = "0.0"
        }
        
        sendStartedListening()
    }
    
    func setShowImage(){
        let now = Date()
        let day = dateUtil.dateToString(theDate: now, outputFormat: "EEE")
        let time = dateUtil.dateToString(theDate: now, outputFormat: "HHmm")
        let timeInt = Int(time)!
        var cat = ""
        var showName = ""
        var presenterName = ""
        var imageName = "live12"
        var showLogoName = ""
        let defaultImg = "live12"
        
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
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = defaultImg
                showLogoName = "logo_heartbeat"
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "live1"
                showLogoName = "logo_quiet_storm"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "live2"
                showLogoName = "logo_capital_in_the_morning"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "live3"
                showLogoName = "logo_the_fuse"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "live6"
                showLogoName = "logo_radio_active"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "live4"
                showLogoName = "logo_the_jam"
            case 1900..<2200:
                presenterName = "Mandi & Neville"
                showName = cons.HITS
                imageName = "live5"
                showLogoName = "logo_hits"
            case 2200..<2400:
                presenterName = "Laid back Dj Mixes"
                imageName = cons.HEARTBEAT
                imageName = "live7"
                showLogoName = "logo_heartbeat"
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "thu":
            switch timeInt {
            case 0..<100:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = defaultImg
                showLogoName = "logo_heartbeat"
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "live1"
                showLogoName = "logo_quiet_storm"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "live2"
                showLogoName = "logo_capital_in_the_morning"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "live3"
                showLogoName = "logo_the_fuse"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "live6"
                showLogoName = "logo_radio_active"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "live4"
                showLogoName = "logo_the_jam"
            case 1900..<2200:
                presenterName = ""
                showName = cons.HITS
                imageName = defaultImg
                showLogoName = "logo_hits"
            case 2200..<2300:
                presenterName = ""
                showName = cons.TED_TALK
                imageName = "live19"
                showLogoName = "logo_ted_talk"
            case 2300..<2400:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = defaultImg
                showLogoName = "logo_heartbeat"
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "fri":
            switch timeInt {
            case 0..<100:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = defaultImg
                showLogoName = "logo_heartbeat"
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "live1"
                showLogoName = "logo_quiet_storm"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "live2"
                showLogoName = "logo_capital_in_the_morning"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "live3"
                showLogoName = "logo_the_fuse"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "live6"
                showLogoName = "logo_radio_active"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "live4"
                showLogoName = "logo_the_jam"
            case 1900..<2100:
                presenterName = "Mandi & Neville"
                showName = cons.HEAT
                imageName = defaultImg
                showLogoName = ""
            case 2100..<2300:
                presenterName = ""
                showName = cons.DANCE_REPUBLIC
                imageName = defaultImg
                showLogoName = "logo_dance_republic"
            case 2300..<2400:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
                showLogoName = ""
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "sat":
            switch timeInt {
            case 0..<200:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
                showLogoName = ""
            case 500..<700:
                presenterName = "Dj Tony"
                showName = cons.INFUSED
                imageName = defaultImg
                showLogoName = "logo_infused"
            case 700..<1000:
                presenterName = "Tracy, Djs Tumz & Lithium"
                showName = cons.SATURDAY_BREAKFAST
                imageName = "live8"
                showLogoName = "logo_sat_breakfast"
            case 1000..<1400:
                presenterName = "Rick Dees"
                showName = cons.RICK_DEES
                imageName = "live9"
                showLogoName = "logo_rick_dees"
            case 1400..<1700:
                presenterName = "Solo, Wokabi & Alex"
                showName = cons.MUSIC_SPORT
                imageName = "live10"
                showLogoName = "logo_sat_music_sports"
            case 1700..<1900:
                presenterName = "Dj Slick"
                showName = cons.CYPHER
                imageName = "live11"
                showLogoName = "logo_the_cypher"
            case 1900..<2100:
                presenterName = "Kui Kabala"
                showName = cons.WORLD_GROOVE
                imageName = "live12"
                showLogoName = "logo_world_groove"
            case 2100..<2300:
                presenterName = "Dj Adrian"
                showName = cons.WHEELZ_STEEL
                imageName = "live13"
                showLogoName = "logo_wheels_of_steel"
            case 2300..<2400:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
                showLogoName = ""
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        case "sun":
            switch timeInt {
            case 0..<200:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = defaultImg
                showLogoName = ""
            case 600..<800:
                presenterName = ""
                showName = cons.LEGENDS
                imageName = defaultImg
                showLogoName = ""
            case 800..<900:
                presenterName = ""
                showName = cons.COUNTRY_ROAD
                imageName = defaultImg
                showLogoName = "logo_country_road"
            case 900..<1100:
                presenterName = "Chao"
                showName = cons.LOUNGE
                imageName = "live14"
                showLogoName = "logo_lounge"
            case 1100..<1300:
                presenterName = "Wokabi & friends"
                showName = cons.FOOTBALL_SUNDAY
                imageName = "live10"
                showLogoName = "logo_football_sunday"
            case 1300..<1500:
                presenterName = "Dj Mo"
                showName = cons.SOUND
                imageName = "live15"
                showLogoName = "logo_the_sound"
            case 1500..<1700:
                presenterName = "Dj Adrian"
                showName = cons.SOUL_GROOVE
                imageName = "live13"
                showLogoName = "logo_world_groove"
            case 1700..<1900:
                presenterName = "Ras Luigi"
                showName = cons.ONE_LOVE
                imageName = "live17"
                showLogoName = "logo_one_love"
            case 1900..<2200:
                presenterName = "Kaima & Jacob Asiyo"
                showName = cons.CAPITAL_JAZZ_CLUB
                imageName = "live16"
                showLogoName = "logo_capital_jazz"
            case 2200..<2300:
                presenterName = ""
                showName = cons.TED_TALK_RPT
                imageName = "live18"
                showLogoName = "logo_ted_talk"
            default:
                presenterName = ""
                showName = ""
                imageName = defaultImg
            }
        default:
            imageName = defaultImg
        }
        
        ivLive.image = UIImage(named: imageName)
        ivShowLogo.image = UIImage(named: showLogoName)
        tvShow.text = showName
        tvPresenter.text = presenterName
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScheduleCell
//        cell.title.text =
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iphoneHeight = 70
        let ipadHeight = 110
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            return CGSize(width: collSchedule.bounds.size.width - 4, height: CGFloat(iphoneHeight))
        } else {
            return CGSize(width: (collSchedule.bounds.size.width/2)-4, height: CGFloat(ipadHeight))
        }
    }
    
    @IBAction func tabSelected(_ sender: Any) {
        if myTabs.selectedSegmentIndex == 0{
            collSchedule.isHidden = true
            ivListenLive.isHidden = false
            tvDay.isHidden = false
            tvShow.isHidden = false
            tvPresenter.isHidden = false
        } else {
            collSchedule.isHidden = false
            ivListenLive.isHidden = true
            tvDay.isHidden = true
            tvShow.isHidden = true
            tvPresenter.isHidden = true
        }
    }
}
