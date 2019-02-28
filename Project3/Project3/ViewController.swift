//
//  ViewController.swift
//  Project3
//
//  Created by Roberto Manese III on 2/27/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites: [String] = ["google.com", "youtube.com", "facebook.com", "apple.com", "hackingwithswift.com", "stackoverflow.com"]

    let https: String = "https://www."
    var website: String = ""

    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: self.progressView)
        self.toolbarItems = [progressButton, spacer, back, spacer, forward, spacer, refresh]
        self.navigationController?.isToolbarHidden = false

        let url = URL(string: https + website)!
        self.webView.load(URLRequest(url: url))
        self.webView.allowsBackForwardNavigationGestures = true

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                } else {
                    let ac = UIAlertController(title: "Blocked website", message: "That website is blocked", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(ac, animated: true)
                }
            }
        }

        decisionHandler(.cancel)
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: openPage))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        self.present(ac, animated: true)
    }

    func openPage(action: UIAlertAction!) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }

}

