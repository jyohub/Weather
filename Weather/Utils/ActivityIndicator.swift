//
//  ActivityIndicator.swift
//  Weather
//
//  Created by jyohub on 2022/03/10.
//

import UIKit

protocol ActivityIndicator {
    var activityIndicatorView : UIActivityIndicatorView { get }
    var loadingView : UIView { get }
    var view : UIView? {  set get}
    
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicator {

    func showActivityIndicator() {
        view?.addSubview(loadingView)
        view?.bringSubviewToFront(loadingView)
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        loadingView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
}

class ActivityIndicatorManager: ActivityIndicator {
    
    weak var view : UIView?
    
    lazy var activityIndicatorView: UIActivityIndicatorView  = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = UIActivityIndicatorView.Style.medium
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = view?.center ?? CGPoint(x: UIScreen.main.bounds.width/2.0, y: UIScreen.main.bounds.height/2.0)
        return activityIndicatorView
    }()
    
    lazy var loadingView : UIView  = {
        let loadingView = UIView()
        loadingView.frame = view?.frame ?? UIScreen.main.bounds
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.7
        loadingView.addSubview(activityIndicatorView)
        return loadingView
    }()
}
