//
//  HeaderView.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/4/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import UIKit

// MARK: Wanted to Add nice First News Article as Header and faced with an issue(with adding searchbar and first article together and some logic). That's why left that part as it is. 

class HeaderView: UIView {
    let viewHeight: CGFloat = 340
    let imageHeight: CGFloat = 250
    
    let titleFrameHeight: CGFloat = 75
    let timeFrameHeight: CGFloat = 10
    
    let xOffset: CGFloat = 10
    let yOffset: CGFloat = 5
    
    let titleFontSize: CGFloat = 20
    let timeFontSize: CGFloat = 8
    
    static let shared = HeaderView()
    
    lazy var newsImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: imageHeight))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    } ()
    
    lazy var newsTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: xOffset / 2, y: newsImageView.frame.height + yOffset, width: frame.width - xOffset, height: titleFrameHeight))
        
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        label.numberOfLines = 3
        
        return label
    } ()
    
    lazy var newsTimeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: xOffset / 2, y: self.frame.height - timeFrameHeight, width: frame.width - xOffset, height: timeFrameHeight))
        
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: timeFontSize)
        
        return label
    } ()
    
//    private override init(frame: CGRect) {
//        super.init(frame: CGRect(x: 0, y: yOffset, width: frame.width, height: viewHeight))
//
//        self.backgroundColor = .white
//        self.layer.cornerRadius = 10
//        self.layer.shadowOffset = CGSize(width: 0, height: 5)
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowRadius = 8
//        self.layer.shadowOpacity = 0.5
//
//        self.addSubview(newsImageView)
//        self.addSubview(newsTitleLabel)
//        self.addSubview(newsTimeLabel)
//    }
    
    func layoutSubviews(article: NewsArticle) {
        newsTitleLabel.text = article.title
        newsTimeLabel.text = article.publishedAt
        newsImageView.image = UIImage(named: "image1")
    }
}
