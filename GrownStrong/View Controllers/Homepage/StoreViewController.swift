//
//  StoreViewController.swift
//  GrownStrong
//
//  Created by Aman on 31/08/21.
//

import UIKit
import WebKit

class StoreViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.openWebURL()
        // Do any additional setup after loading the view.
    }
    
    func openWebURL(){
        let rqst = URLRequest(url: URL(string: "https://www.google.com")!)
        webView.load(rqst)
        webView.allowsBackForwardNavigationGestures = true

    }

}
