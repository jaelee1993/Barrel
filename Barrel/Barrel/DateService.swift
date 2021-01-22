//
//  DateService.swift
//  Barrel
//
//  Created by Jae Lee on 7/25/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation

class DateService {
    static let F1             = "MMM d, h:mm a"
    static let F2             = "MMM d"
    static let F3             = "E M/d"
    static let F101           = "h a"
    
    
    
    static func convertStringToDate(_ dateString:String, fromFormat:String, toFormat:String)->String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = fromFormat
        let date:Date = dateFormatter1.date(from: dateString)!
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = toFormat
        return dateFormatter2.string(from: date)
    }
    
    static func convertDate(_ date:Date, format:String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func getDateFor(days:Int) -> Date? {
         return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }
}
