//
//  ViewController.swift
//  foreignpolicy
//
//  Created by Даниил on 09.11.2022.
//

import UIKit
import WebKit

class feedViewController: UIViewController {
    
    // MARK: Properties
    private var webView = WKWebView()
    private let loadingLabel = loading()
    private var transitions: ListTransitions = ListTransitions(post: "")
    
    // MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupJSHandler()
        getUrlForLoadRequest()
    }
    
    // MARK: Selectors
    private func configureView(){
        title = "feed"
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
        /// adding loading label to view
        loadingLabel.addToView(with: view)
    }
    
    private func getUrlForLoadRequest() {
        guard let request = urlFeedHandler.shared.createdRequest() else { return }
        webView.load(request)
    }
    
    /// preparing js for injection
    private func setupJSHandler() {
        let js = urlFeedHandler.shared.javaScript
        let javaScriptEventName = urlFeedHandler.shared.javaScriptEventName
        self.setupWebViewJStHandler(with: js,
                                    eventName: javaScriptEventName)
    }
    
    /// inject js to receive data-ml-post-id of article
    private func setupWebViewJStHandler(with js: String, eventName name: String) {
        let jsHandler = WKUserScript(source: js,
                                     injectionTime: .atDocumentStart,
                                     forMainFrameOnly: true)
        
        webView.configuration.userContentController.addUserScript(jsHandler)
        webView.configuration.userContentController.add(self, name: name)
    }
    
}

// MARK: - WKScriptMessageHandler
extension feedViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        /// retrieving postId for url
        guard let postId = message.body as? String else {
            return
        }
        transitions = ListTransitions(post: postId)
        let vc = postViewController()
        vc.postID = transitions.post
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension feedViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.5){
            self.webView.alpha = 1
            self.loadingLabel.removeFromView(with: self.view)
        }
    }
}

