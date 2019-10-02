//
//  Colors.swift
//  CapitalFM
//
//  Created by mac on 18/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import Foundation
import UIKit

public class MyExtensions : NSObject {
    
}

extension UIColor {
    struct MyTheme {
//        static var primaryColor: UIColor  { return UIColor(red: 0.86, green: 0.09, blue: 0.1, alpha: 1) }
        static var primaryColor: UIColor  { return UIColor(red: 210/255, green: 0, blue: 1/255, alpha: 1) }
        static var accentColor: UIColor { return UIColor(red: 1, green: 0.98, blue: 0, alpha: 1) }
        static var fbColor: UIColor { return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1) }
    }
}
extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}
