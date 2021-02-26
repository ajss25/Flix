//
//  MovieTrailerViewController.swift
//  Flix
//
//  Created by Alex Shin on 2/25/21.
//

import UIKit
import WebKit

class MovieTrailerViewController: UIViewController, WKUIDelegate {

    var trailerLink: URL!
    var webView: WKWebView!
    
    // Receive trailer URL and play trailer modally
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let URL = trailerLink
        let request = URLRequest(url: URL!)
        webView.load(request)
    }
}
