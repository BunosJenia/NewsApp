//
//  AppController.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/3/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import UIKit

class AppController: UITableViewController {
    var filteredArticles = [NewsArticle]()
    var newsArticles = [NewsArticle]()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var isFetchingMoreData: Bool = false
    var maxFetchingDataCount: Int = 7
    var dayCount: Int = 0
    
    var newsAPIManager = NewsAPIManager()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search News"
        searchController.searchBar.delegate = self
        
        return searchController
    } ()
    
    let newsRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = .clear
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupTableViewData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestNews()
    }
}

// MARK: TableView methods
extension AppController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArticles.count
        }
        
        return newsArticles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as! TableViewCell
        let article: NewsArticle
        
        if isFiltering {
            article = filteredArticles[indexPath.row]
        } else {
            article = newsArticles[indexPath.row]
        }
        
        cell.data = article
        cell.frame.size.width = self.tableView.frame.width
        tableView.rowHeight = cell.getRowHeight()
        
        return cell
    }
}

// MARK: Push-to-Refresh and ScrollView methods
extension AppController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        
        if offsetY > contentSize - scrollView.frame.height {
            if isFetchingMoreData == false && maxFetchingDataCount > dayCount && newsArticles.count > 0 {
                self.isFetchingMoreData = true
                
                self.requestNews()
            }
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.showActivityIndicator()
        
        refreshNews()
        sender.endRefreshing()
    }
}

// MARK: APIManager wrapper for getting News
extension AppController {
    func refreshNews() {
        self.dayCount = 0
        
        newsAPIManager.getNews(daysAgo: self.dayCount, onSuccess: { result in
            DispatchQueue.main.async {
                self.newsArticles.removeAll()
                self.updateNewsArticles(result: result)
            }
        }, onFailure: {
            self.showAlert()
        })
    }
    
    func requestNews() {
        self.showActivityIndicator()
        
        newsAPIManager.getNews(daysAgo: self.dayCount, onSuccess: { result in
            DispatchQueue.main.async {
                self.addHeader()
                self.updateNewsArticles(result: result)
            }
        }, onFailure: {
            self.showAlert()
        })
    }
}

// MARK: Setup Main Views and ActivityIndicator methods
extension AppController {
    func addHeader() {
        if self.dayCount == 0 {
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
    }
    
    func setupTableViewData() {
        self.tableView.backgroundColor = .clear
        self.tableView.separatorColor = .clear
        self.tableView.backgroundColor = .white
        self.tableView.alwaysBounceVertical = false
        self.tableView.refreshControl = newsRefreshControl

        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    func showActivityIndicator() {
        LoaderView.shared.showLoader()
    }
    
    func hideActivityIndicator() {
        LoaderView.shared.hideLoader()
    }
    
    func showAlert() {
        DispatchQueue.main.async {
           let alert = UIAlertController(title: "Error", message: "Something go wrong.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
                exit(0)
            }))
            self.present(alert, animated: true)

            self.hideActivityIndicator()
        }
    }
    
    func updateNewsArticles(result: [NewsArticle]) {
        self.appendUniqueArticles(articles: result)
        self.tableView.reloadData()
        self.isFetchingMoreData = false
        self.dayCount += 1
        self.hideActivityIndicator()
    }
}

// MARK: Add new NewsArticles
extension AppController {
    private func appendUniqueArticles(articles: [NewsArticle]) {
        for article in articles {
            if !self.newsArticles.contains(article) {
                self.newsArticles.append(article)
            }
        }
    }
    
    private func appendUniqueArticlesToStartPossition(articles: [NewsArticle]) {
        var newArticles: [NewsArticle] = []
        
        for article in articles {
            if !self.newsArticles.contains(article) {
                newArticles.append(article)
            }
        }
        
        if !newArticles.isEmpty {
            self.newsArticles.insert(contentsOf: newArticles, at: 0)
        }
    }
}

// MARK: SearchBar functionality

extension AppController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredArticles = newsArticles.filter { (article: NewsArticle) -> Bool in
            return article.title.lowercased().contains(searchText.lowercased())
        }
      
        tableView.reloadData()
    }
}
