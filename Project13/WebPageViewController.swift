//
//  WebPageViewController.swift
//  Project13
//
//  Created by Roberto Manese III on 5/8/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController {

    var webView: WKWebView!

    let url = "https://en.wikipedia.org/wiki/"
    var location: String?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let location = location else {
            return
        }
        guard let url = URL(string: url + location) else { return }
        webView.load(URLRequest(url: url))

    }

}
