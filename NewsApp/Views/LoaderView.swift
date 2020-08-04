//
//  LoaderView.swift
//  NewsApp
//
//  Created by Yauheni Bunas on 8/3/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import UIKit
import Lottie

class LoaderView: UIView {
    static let shared: LoaderView = {
        let instance = LoaderView()
        return instance
    }()
    
    lazy var loaderView: AnimationView = {
        let animationView = AnimationView(name: "load")
    
        animationView.frame = UIScreen.main.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
        
        return animationView
    } ()
    
    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: UIScreen.main.bounds)
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = false
        
        return transparentView
    } ()
    
    func showLoader() {
        self.addSubview(transparentView)
        self.transparentView.addSubview(loaderView)
        
        self.loaderView.play()
        
        UIApplication.shared.keyWindow?.addSubview(self.transparentView)
    }
    
    func hideLoader() {
        self.transparentView.removeFromSuperview()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
