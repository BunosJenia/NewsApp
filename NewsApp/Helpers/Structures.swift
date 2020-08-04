//
//  Structures.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/3/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}

struct NewsArticle: Codable, Equatable {
    let source: NewsArticleSource
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    static func == (lhs: NewsArticle, rhs: NewsArticle) -> Bool {
        return lhs.title == rhs.title
    }
}

struct NewsArticleSource: Codable {
    let id: String?
    let name: String
}
