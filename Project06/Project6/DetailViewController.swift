//
//  DetailViewController.swift
//  Project6
//
//  Created by Roberto Manese III on 3/11/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = self.detailItem else { return }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
            <h1>\(detailItem.title)</h1>
            <p>\(detailItem.body)</p>
        </body>
        </html>
        """

        self.webView.loadHTMLString(html, baseURL: nil)
    }

}
