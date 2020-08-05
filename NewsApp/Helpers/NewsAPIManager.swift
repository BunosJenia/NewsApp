//
//  NewsApiService.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/3/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import Foundation

class NewsAPIManager {
    let secondsInDay: Int = -86400
    let dateFormatterPattern = "yyyy-MM-dd"
    let url = "https://newsapi.org/v2/everything?domains=thenextweb.com&from=%@&pageSize=100&apiKey=%@"
    let urlFromTo = "https://newsapi.org/v2/everything?domains=thenextweb.com&from=%@&to=%@&pageSize=100&apiKey=%@"
    
    func getNews(daysAgo: Int, onSuccess: @escaping([NewsArticle]) -> Void, onFailure: @escaping() -> Void) {
        let task = URLSession.shared.dataTask(with: self.getUrl(daysAgo: daysAgo), completionHandler: {data, response, error in
            guard let data = data, error == nil else { return }

            var json: NewsResponse?
            do {
                json = try JSONDecoder().decode(NewsResponse.self, from: data)
            } catch {
                onFailure()
            }
            
            guard let result = json else { return }

            onSuccess(result.articles)
        })

        task.resume()
    }
}

extension NewsAPIManager {
    private func getUrl(daysAgo: Int) ->URL {
        if daysAgo == 0 {
            let formatter = ISO8601DateFormatter()
            let fromDate = formatter.string(from: Date.init(timeIntervalSinceNow: TimeInterval(secondsInDay)))
            let latestUrl = NSString(format: url as NSString, fromDate, APIKey)
            
            return URL(string: latestUrl as String)!
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatterPattern
        
        let fromDate = formatter.string(from: Date.init(timeIntervalSinceNow: TimeInterval(secondsInDay * daysAgo)))
        
        let myUrl = NSString(format: urlFromTo as NSString, fromDate, fromDate, APIKey)
        
        return URL(string: myUrl as String)!
    }
}
