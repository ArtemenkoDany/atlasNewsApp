//
//  urlFeedHandler.swift
//  foreignpolicy
//
//  Created by Даниил on 10.11.2022.
//

import Foundation

class urlFeedHandler{
    
    // MARK: Properties
    static let shared = urlFeedHandler()
    
    public let feedUrl = "https://theatlasnews.co/ml-api/v2/list"
    public let javaScriptEventName = "jsMessenger"
    public let javaScript = """
                window.onload = function() {
                    let id = ""
                    function clickHandler()  {
                        let ctas = document.querySelectorAll('.article-list__wrap');
                        ctas.forEach(cta => {
                            cta.addEventListener('click', (post) => {
                                try {
                                    let elt = post.target.closest("ons-list-item");
                                    let postId = elt.getAttribute('data-ml-post-id');
                                    if (id == postId) { return }
                                    else {
                                        id = postId;
                                    }

                                    window.webkit.messageHandlers.jsMessenger.postMessage(postId);
                                } catch {}
                            });
                        });
                    }

                    var observer = new MutationObserver(function(mutations) {
                        mutations.forEach(function(mutationRecord) {
                            clickHandler()
                        });
                    });
                    var target = document.getElementById('article-list');
                    var observerConfig = {
                        attributes: true,
                        childList: true,
                        characterData: true
                    };
                    observer.observe(target, observerConfig);
                    clickHandler()
                }
                """
    
    // MARK: Selectors
    func createdRequest() -> URLRequest? {
        guard let url = URL(string: feedUrl) else { return nil }

        return URLRequest(url: url)
    }
    
}
