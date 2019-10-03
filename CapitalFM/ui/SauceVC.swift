//
//  NewsVC.swift
//  CapitalFM
//
//  Created by mac on 01/10/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
import MBProgressHUD

class SauceVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collView: UICollectionView!
    
    var sauceArray = [Feed]()
    var appUtil = AppUtil()
    var selectedUrl : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSauce()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sauceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCell
        
        let item = sauceArray[indexPath.row]
        cell.title.text = item.title.rendered
        
        let imageUrl = URL(string: item.imageUrl)
        cell.iv.kf.setImage(with: imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iphoneHeight = 100
        let ipadHeight = 140
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            return CGSize(width: collectionView.bounds.size.width - 4, height: CGFloat(iphoneHeight))
        } else {
            return CGSize(width: (collectionView.bounds.size.width/2)-4, height: CGFloat(ipadHeight))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedUrl = URL(string: sauceArray[indexPath.row].link)
        performSegue(withIdentifier: "segueWeb", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MyWebViewVC
        vc.url = selectedUrl
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            
            let results = regex.matches(in: text,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            
            return []
        }
        
    }
    
    func fetchSauce(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.label.text = "loading..."
        
        Alamofire.request(MyConstants().URL_FEED_SAUCE).responseJSON { response in
            switch response.result {
                
            case .success(let res):
                let sauceJson = JSON(res)
                
                //                print(sauceJson)
                
                for i in 0 ..< sauceJson.count{
                    let link = sauceJson[i]["link"].string ?? ""
                    let title = sauceJson[i]["title"]["rendered"].string?.htmlDecoded ?? ""
                    let content = sauceJson[i]["content"]["rendered"].string ?? ""
                    var url = ""
                    
                    if let match = content.range(of: "src=\"(.*?)\"", options: .regularExpression) {
                        var src = String(content[match])
                        src = src.replacingOccurrences(of: "src=", with: "", options: NSString.CompareOptions.literal, range:nil)
                        url = src.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
                    }
                    
                    self.sauceArray.append(Feed(link: link, title: Title(rendered: title), imageUrl: url))
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
