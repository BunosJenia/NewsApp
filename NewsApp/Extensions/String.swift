//
//  String.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/4/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import Foundation

extension String {
    static func iso8601DateToNormalDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        return dateFormatter.string(for: date)!
    }
}
