//
//  UIImage.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/4/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(urlString: String?) {
        if urlString == nil {
            self.image = UIImage(named: "image") 
            
            return
        }
        
        if let cacheImage = NSCache<AnyObject, AnyObject>().object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }

        guard let url = URL(string: urlString!) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }

            guard let data = data else { return }
            let image = UIImage(data: data)
            NSCache<AnyObject, AnyObject>().setObject(image as! UIImage, forKey: urlString as AnyObject)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
