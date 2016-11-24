//
//  InfoSessionWebsiteViewController.swift
//  UW Info Session
//
//  Created by Qiu Zefeng on 2015-09-07.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import WebKit

class InfoSessionWebsiteViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView
    
    var refreshBarButtonItem: UIBarButtonItem!
    var forwardBarButtonItem: UIBarButtonItem!
    var backwardBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var websiteURLString: String?
    var websiteName: String?
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)!
        self.webView.navigationDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding multi-button in the right side of navigation bar
        refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "stopReload:")
        forwardBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FastForward, target: self, action: "goForward:")
        backwardBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Rewind, target: self, action: "goBack:")
        self.navigationItem.setRightBarButtonItems([refreshBarButtonItem, forwardBarButtonItem, backwardBarButtonItem], animated: true)
        title = websiteName
        
        // autolayout for web view
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        // this line of code can disables auto-generated constraints so that tou can create your own
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -49)
        view.addConstraint(heightConstraint)
        
        // loading the web page
        let URL = NSURL(string: websiteURLString!)
        let request = NSURLRequest(URL: URL!)
        webView.loadRequest(request)
        
        forwardBarButtonItem.enabled = false
        backwardBarButtonItem.enabled = false
        
        progressView.setProgress(0.0, animated: false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    //MARK: WKNav delegate
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    //MARK: concerning the progress view
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "loading") {
            backwardBarButtonItem.enabled = webView.canGoBack
            forwardBarButtonItem.enabled = webView.canGoForward
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
            //            if (webView.loading == false) {
            //                println(websiteURLString)
            //                websiteURLString = webView.URL!.absoluteString
            //            }
        } else if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    //MARK: function for buttons
    
    func goBack(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    func goForward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    func stopReload(sender: UIBarButtonItem) {
        if (webView.loading) {
            webView.stopLoading()
        } else {
            let request = NSURLRequest(URL:webView.URL!)
            webView.loadRequest(request)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
