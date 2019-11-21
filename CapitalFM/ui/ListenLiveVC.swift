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
    
    @IBOutlet weak var tvShow2: UILabel!
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
        
        Alamofire.request(cons.stopListeningUrl(), method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: nil).responseJSON(completionHandler: {response in
            
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
        var airDay = "MON - FRI"
        var airTime = "10:00 - 12:00"
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
                imageName = "heartbeat"
                showLogoName = "logo_heartbeat"
                airDay = "MON - FRI"
                airTime = "00:00 - 01:00"
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "queiet_storm"
                showLogoName = "logo_quiet_storm"
                airDay = "MON - FRI"
                airTime = "05:00 - 06:00"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "capital_in_the_morning"
                showLogoName = "logo_capital_in_the_morning"
                airDay = "MON - FRI"
                airTime = "06:00 - 10:00"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "the_fuse"
                showLogoName = "logo_the_fuse"
                airDay = "MON - FRI"
                airTime = "10:00 - 14:00"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "radio_active"
                showLogoName = "logo_radio_active"
                airDay = "MON - FRI"
                airTime = "14:00 - 15:00"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "the_jam"
                showLogoName = "logo_the_jam"
                airDay = "MON - FRI"
                airTime = "15:00 - 19:00"
            case 1900..<2200:
                presenterName = "Mandi & Neville"
                showName = cons.HITS
                imageName = "hits"
                showLogoName = "logo_hits"
                airDay = "MON - FRI"
                airTime = "19:00 - 22:00"
            case 2200..<2400:
                presenterName = "Laid back Dj Mixes"
                imageName = cons.HEARTBEAT
                imageName = "heartbeat"
                showLogoName = "logo_heartbeat"
                airDay = "MON - FRI"
                airTime = "22:00 - 01:00"
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
                imageName = "heartbeat"
                showLogoName = "logo_heartbeat"
                airDay = "MON - FRI"
                airTime = "00:00 - 01:00"
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "queiet_storm"
                showLogoName = "logo_quiet_storm"
                airDay = "MON - FRI"
                airTime = "05:00 - 06:00"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "capital_in_the_morning"
                showLogoName = "logo_capital_in_the_morning"
                airDay = "MON - FRI"
                airTime = "06:00 - 10:00"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "the_fuse"
                showLogoName = "logo_the_fuse"
                airDay = "MON - FRI"
                airTime = "10:00 - 14:00"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "radio_active"
                showLogoName = "logo_radio_active"
                airDay = "MON - FRI"
                airTime = "14:00 - 15:00"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "the_jam"
                showLogoName = "logo_the_jam"
                airDay = "MON - FRI"
                airTime = "15:00 - 19:00"
            case 1900..<2200:
                presenterName = ""
                showName = cons.HITS
                imageName = "hits"
                showLogoName = "logo_hits"
                airDay = "MON - FRI"
                airTime = "19:00 - 22:00"
            case 2200..<2300:
                presenterName = ""
                showName = cons.TED_TALK
                imageName = "ted_talk"
                showLogoName = "logo_ted_talk"
                airDay = "THU, SUN"
                airTime = "22:00 - 23:00"
            case 2300..<2400:
                presenterName = "Laid back Dj Mixes"
                showName = cons.HEARTBEAT
                imageName = "heartbeat"
                showLogoName = "logo_heartbeat"
                airDay = "MON - FRI"
                airTime = "23:00 - 01:00"
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
                imageName = "heartbeat"
                showLogoName = "logo_heartbeat"
                airDay = "MON - FRI"
                airTime = "00:00 - 01:00"
            case 500..<600:
                presenterName = "Dj Tony"
                showName = cons.QUIET_STORM
                imageName = "queiet_storm"
                showLogoName = "logo_quiet_storm"
                airDay = "MON - FRI"
                airTime = "05:00 - 06:00"
            case 600..<1000:
                presenterName = "Amina & Fareed"
                showName = cons.CAPITAL_MORNING
                imageName = "capital_in_the_morning"
                showLogoName = "logo_capital_in_the_morning"
                airDay = "MON - FRI"
                airTime = "06:00 - 10:00"
            case 1000..<1400:
                presenterName = "Anne & Miano"
                showName = cons.FUSE
                imageName = "the_fuse"
                showLogoName = "logo_the_fuse"
                airDay = "MON - FRI"
                airTime = "10:00 - 14:00"
            case 1400..<1500:
                presenterName = "One hour of Amazing Dj mixes"
                showName = cons.RADIO_ACTIVE
                imageName = "radio_active"
                showLogoName = "logo_radio_active"
                airDay = "MON - FRI"
                airTime = "14:00 - 15:00"
            case 1500..<1900:
                presenterName = "Joey & Martin"
                showName = cons.JAM
                imageName = "the_jam"
                showLogoName = "logo_the_jam"
                airDay = "MON - FRI"
                airTime = "15:00 - 19:00"
            case 1900..<2100:
                presenterName = "Mandi & Neville"
                showName = cons.HEAT
                imageName = "the_heat"
                showLogoName = ""
                airDay = "FRI"
                airTime = "19:00 - 22:00"
            case 2100..<2300:
                presenterName = ""
                showName = cons.DANCE_REPUBLIC
                imageName = "dance_republic"
                showLogoName = "logo_dance_republic"
                airDay = "FRI"
                airTime = "21:00 - 23:00"
            case 2300..<2400:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = "capital_club"
                showLogoName = ""
                airDay = "FRI"
                airTime = "23:00 - 02:00"
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
                imageName = "capital_club"
                airDay = "SAT"
                airDay = ""
                airTime = "00:00 - 02:00"
            case 500..<700:
                presenterName = "Dj Tony"
                showName = cons.INFUSED
                imageName = "infused"
                showLogoName = "logo_infused"
                airDay = "SAT"
                airTime = "05:00 - 07:00"
            case 700..<1000:
                presenterName = "Tracy, Djs Tumz & Lithium"
                showName = cons.SATURDAY_BREAKFAST
                imageName = "sat_breakfast"
                showLogoName = "logo_sat_breakfast"
                airDay = "SAT"
                airTime = "07:00 - 10:00"
            case 1000..<1400:
                presenterName = "Rick Dees"
                showName = cons.RICK_DEES
                imageName = "rick_dees"
                showLogoName = "logo_rick_dees"
                airDay = "SAT"
                airTime = "10:00 - 14:00"
            case 1400..<1700:
                presenterName = "Solo, Wokabi & Alex"
                showName = cons.MUSIC_SPORT
                imageName = "sat_music_sports"
                showLogoName = "logo_sat_music_sports"
                airDay = "SAT"
                airTime = "14:00 - 17:00"
            case 1700..<1900:
                presenterName = "Dj Slick"
                showName = cons.CYPHER
                imageName = "the_cypher"
                showLogoName = "logo_the_cypher"
                airDay = "SAT"
                airTime = "17:00 - 19:00"
            case 1900..<2100:
                presenterName = "Kui Kabala"
                showName = cons.WORLD_GROOVE
                imageName = "world_groove"
                showLogoName = "logo_world_groove"
                airDay = "SAT"
                airTime = "19:00 - 21:00"
            case 2100..<2300:
                presenterName = "Dj Adrian"
                showName = cons.WHEELZ_STEEL
                imageName = "wheels_of_steel"
                showLogoName = "logo_wheels_of_steel"
                airDay = "SAT"
                airTime = "21:00 - 23:00"
            case 2300..<2400:
                presenterName = ""
                showName = cons.CLUB_CAPITAL
                imageName = "capital_club"
                showLogoName = ""
                airDay = "SAT"
                airTime = "23:00 - 02:00"
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
                imageName = "capital_club"
                showLogoName = ""
                airDay = "SUN"
                airTime = "00:00 - 02:00"
            case 600..<800:
                presenterName = ""
                showName = cons.LEGENDS
                imageName = "legends"
                showLogoName = ""
                airDay = "SUN"
                airTime = "06:00 - 08:00"
            case 800..<900:
                presenterName = ""
                showName = cons.COUNTRY_ROAD
                imageName = "country_road"
                showLogoName = "logo_country_road"
                airDay = "SUN"
                airTime = "08:00 - 09:00"
            case 900..<1100:
                presenterName = "Chao"
                showName = cons.LOUNGE
                imageName = "the_lounge"
                showLogoName = "logo_lounge"
                airDay = "SUN"
                airTime = "09:00 - 11:00"
            case 1100..<1300:
                presenterName = "Wokabi & friends"
                showName = cons.FOOTBALL_SUNDAY
                imageName = "sunday_football"
                showLogoName = "logo_football_sunday"
                airDay = "SUN"
                airTime = "11:00 - 13:00"
            case 1300..<1500:
                presenterName = "Dj Mo"
                showName = cons.SOUND
                imageName = "the_sound"
                showLogoName = "logo_the_sound"
                airDay = "SUN"
                airTime = "13:00 - 15:00"
            case 1500..<1700:
                presenterName = "Dj Adrian"
                showName = cons.SOUL_GROOVE
                imageName = "world_groove"
                showLogoName = "logo_world_groove"
                airDay = "SUN"
                airTime = "15:00 - 17:00"
            case 1700..<1900:
                presenterName = "Ras Luigi"
                showName = cons.ONE_LOVE
                imageName = "one_love"
                showLogoName = "logo_one_love"
                airDay = "SUN"
                airTime = "17:00 - 19:00"
            case 1900..<2200:
                presenterName = "Kaima & Jacob Asiyo"
                showName = cons.CAPITAL_JAZZ_CLUB
                imageName = "jazz_club"
                showLogoName = "logo_capital_jazz"
                airDay = "SUN"
                airTime = "19:00 - 22:00"
            case 2200..<2300:
                presenterName = ""
                showName = cons.TED_TALK_RPT
                imageName = "ted_talk"
                showLogoName = "logo_ted_talk"
                airDay = "THU, SUN"
                airTime = "22:00 - 23:00"
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
        tvShow2.text = showName
        tvDay.text = airDay + " " + airTime
        tvPresenter.text = presenterName
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cons.SHOWS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScheduleCell
        let show = cons.SHOWS[indexPath.row]
        cell.iv.image = UIImage(named: show.showLogo)
        cell.title.text = show.showName
        cell.tvDay.text = show.showDay
        cell.tvTime.text = show.startTime + " - " + show.endTime
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
