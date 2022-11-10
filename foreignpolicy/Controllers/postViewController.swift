//
//  postViewController.swift
//  foreignpolicy
//
//  Created by Даниил on 10.11.2022.
//

import UIKit
import WebKit

class postViewController: UIViewController {
    // MARK: Properties
    private var webView = WKWebView()
    private let loadingLabel = loading()
    private let postUrl = "https://theatlasnews.co/ml-api/v2/post?post_id="
    public var postID: String = ""
    
    // MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createdRequest()
        configureView()
    }
    
    // MARK: Selectors
    private func configureView(){
        title = "Post"
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        webView.alpha = 0
        webView.navigationDelegate = self
        webView.anchor(top: view.topAnchor,
                       left: view.leftAnchor,
                       bottom: view.bottomAnchor,
                       right: view.rightAnchor,
                       paddingTop: 0,
                       paddingLeft: 0,
                       paddingBottom: 0,
                       paddingRight: 0,
                       width: 0,
                       height: 0)
        
        loadingLabel.addToView(with: view)
    }
    
    /// create url for post
    private func createdRequest() {
        let urlString = "\(postUrl)\(postID)"
        print(urlString)
        guard let url = URL(string: urlString) else{
            return
        }
        webView.load(URLRequest(url: url))
    }
}

// MARK: - WKNavigationDelegate
extension postViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.5){
            self.webView.alpha = 1
            self.loadingLabel.removeFromView(with: self.view)
        }
        
    }
}
