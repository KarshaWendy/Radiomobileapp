//
//  DateUtil.swift
//  CapitalFM
//
//  Created by mac on 25/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import Foundation

class DateUtil {
    func formatDuration(duration: Int) -> String {
        let d = TimeInterval(duration / 1000)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        return formatter.string(from: d)!
    }
    
    func formatDate(theDate: String, inputFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        if let date = formatter.date(from: theDate){
            formatter.dateFormat = "EEE, dd MMM yyyy"
            //formatter.timeZone = NSTimeZone(abbreviation: "GMT+3")
            return formatter.string(from: date)
        } else {
            return "Unknown Date"
        }
    }
}
