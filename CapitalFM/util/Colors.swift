//
//  Colors.swift
//  CapitalFM
//
//  Created by mac on 18/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import Foundation
import UIKit

public class Color : NSObject {
    let primaryColor = UIColor(red: 0.96, green: 0.94, blue: 0.88, alpha: 1.0)
}

extension UIColor {
    struct MyTheme {
        static var primaryColor: UIColor  { return UIColor(red: 0.86, green: 0.09, blue: 0.1, alpha: 1) }
        static var accentColor: UIColor { return UIColor(red: 1, green: 0.98, blue: 0, alpha: 1) }
    }
}
