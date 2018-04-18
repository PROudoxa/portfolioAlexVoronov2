//
//  WebRepoViewController.swift
//  TestGitHubApi
//
//  Created by Alex Voronov on 09.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class WebRepoViewController: UIViewController {

    // MARK: Properties
    var url = "http://github.com"
    
    // MARK: IBOutlets
    @IBOutlet weak var repoWebView: UIWebView!
    @IBOutlet var loadSpinner: UIActivityIndicatorView!

    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoWebView.delegate = self
        
        showRepoWebPage()
    }
}

// MARK: IBActions
extension WebRepoViewController {
    
    @IBAction func goBackTapped(_ sender: UIBarButtonItem) {
        repoWebView.stopLoading()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Private
private extension WebRepoViewController {

    func showRepoWebPage() {

        let url = URL(string: self.url)
        let requestObj = URLRequest(url: url!)
        self.repoWebView.loadRequest(requestObj)
    }
}

// MARK: UIWebViewDelegate
extension WebRepoViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadSpinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadSpinner.stopAnimating()
    }
}
