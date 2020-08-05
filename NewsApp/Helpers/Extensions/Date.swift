//
//  Date.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/4/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import Foundation

extension DateFormatter {
    func iso8601StringToDate(from: String) ->Date {
        let formatString = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        self.dateFormat = formatString
        
        return self.date(from: from)!
    }
}
