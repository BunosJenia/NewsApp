//
//  CoreDataHelper.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/4/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import UIKit
import CoreData

// MARK: Add Template to Store Data in CoreDate.
struct CoreDataHelper {
    static let entityName = "Article"
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newArticle(newsArticle: NewsArticle) -> Article {
        let article = NSEntityDescription.insertNewObject(forEntityName: CoreDataHelper.entityName, into: context) as! Article
        let dateFormatter = DateFormatter()

        
        article.title = newsArticle.title
        article.publishedAt = dateFormatter.iso8601StringToDate(from: newsArticle.publishedAt)
        article.title = newsArticle.title
        
        return article
    }
    
    static func saveArticle() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteArticle(_ article: Article) {
        context.delete(article)
        
        saveArticle()
    }
    
    static func retrieveArticles() -> [Article] {
        do {
            let fetchRequest = NSFetchRequest<Article>(entityName: CoreDataHelper.entityName)
            var results = try context.fetch(fetchRequest)
            
            results.sort(by: { $0.publishedAt!.timeIntervalSince1970 > $1.publishedAt!.timeIntervalSince1970 })
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")

            return []
        }
    }
}
