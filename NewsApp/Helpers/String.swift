//
//  String.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/5/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import Foundation

extension String {
    func iso8601ToNormalDateString(date: String) ->String {
        let dateFormatter = DateFormatter()
        let formatString = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.iso8601StringToDate(from: date)
        
        dateFormatter.dateFormat = formatString
        
        return dateFormatter.string(from: date)
    }
}
