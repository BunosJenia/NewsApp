//
//  TableViewCell.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/3/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    let cellHeight: CGFloat = 110
    let imageWidth: CGFloat = 180
    
    let titleFrameHeight: CGFloat = 70
    let timeFrameHeight: CGFloat = 10
    
    let xOffset: CGFloat = 10
    let yOffset: CGFloat = 5
    
    let titleFontSize: CGFloat = 16
    let showMoreFontSize: CGFloat = 12
    let timeFontSize: CGFloat = 10
    
    static let identifier: String = "Main"
    var data: NewsArticle?
    
    lazy var mainView: UIView = {
        let view = UIView(frame: getMainViewFrame())
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.5
        
        return view
    } ()
    
    lazy var newsImageView: UIImageView = {
        let imageView = UIImageView(frame: getImageViewFrame())
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    } ()
    
    lazy var newsTitleLabel: UILabel = {
        let label = UILabel(frame: getTitleViewFrame())
        
        label.textAlignment = .natural
        label.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        label.numberOfLines = 3
        
        return label
    } ()
    
    lazy var newsTimeLabel: UILabel = {
        let label = UILabel(frame: getTimeViewFrame())
        
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: timeFontSize)
        
        return label
    } ()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layoutMargins = .zero
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let data = data {
            newsTitleLabel.text = data.title
            newsTimeLabel.text = data.publishedAt.iso8601ToNormalDateString(date: data.publishedAt)
            newsImageView.loadImage(urlString: data.urlToImage)
            
            self.newsTitleLabel.addTrailing(with: "... ", moreText: "Show More", moreTextFont: UIFont.systemFont(ofSize: showMoreFontSize), moreTextColor: UIColor.blue)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(mainView)
        mainView.addSubview(newsImageView)
        mainView.addSubview(newsTitleLabel)
        mainView.addSubview(newsTimeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewCell {
    func getMainViewFrame() ->CGRect {
        return CGRect(x: xOffset, y: yOffset, width: frame.width - xOffset * 2, height: cellHeight)
    }
    
    func getImageViewFrame() ->CGRect {
        return CGRect(x: 0, y: 0, width: imageWidth, height: cellHeight)
    }
    
    func getTitleViewFrame() ->CGRect {
        return CGRect(x: imageWidth + xOffset / 2, y: yOffset, width: mainView.frame.size.width - imageWidth - xOffset, height: titleFrameHeight)
    }
    
    func getTimeViewFrame() ->CGRect {
        return CGRect(x: newsTitleLabel.frame.minX, y: mainView.frame.size.height - timeFrameHeight - yOffset, width: newsTitleLabel.frame.width, height: timeFrameHeight)
    }
    
    func getRowHeight() -> CGFloat {
        return cellHeight + yOffset * 2
    }
}
