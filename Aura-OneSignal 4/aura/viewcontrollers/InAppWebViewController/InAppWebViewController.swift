//
//  InAppWebViewController.swift
//  Aura
//
//  Created by Apple on 07/12/15.
//  Copyright © 2015 necixy. All rights reserved.
//

import UIKit

class InAppWebViewController: UIViewController , UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    var urlString : String!
    var timerrequest : Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView : UIView = UIView()
        
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 180, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 180, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        headerLbl.text = "Aura"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
        
        timerrequest = 1;
       // let url = NSURL(string: "https://www.youtube.com/watch?v=opXrOYAKvT0")
     NSURLCache .sharedURLCache().removeAllCachedResponses()
        self.activityIndi.startAnimating()
        self .loadWebView()
        
     

        // Do any additional setup after loading the view.
    }
 func loadWebView()
 {
     //  let url = NSURL(string:urlString)
   // webView.allowsInlineMediaPlayback = true
   // let loadRequest = NSURLRequest(URL: url!, cachePolicy: .ReloadRevalidatingCacheData, timeoutInterval: 10)
    let loadRequest = NSURLRequest(URL:  NSURL(string:urlString)!)
    
    webView.loadRequest(loadRequest)
    
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backONWebViewPage(sender: AnyObject) {
        self.webView.goBack()
    }
    @IBAction func reloadAllWebData(sender: AnyObject) {
          self.activityIndi.startAnimating()
        self.webView.reload()
    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

// MARK: --------------- WebView Delegate

  
    func webViewDidStartLoad(webView : UIWebView) {
       
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
     
        if error!.code != -999
        {
                 globalAlertView("Unable to complete request.", viewCont: self)
        }
            self.activityIndi.stopAnimating()
            self.activityIndi.hidden  = true
    }
    func webViewDidFinishLoad(webView : UIWebView) {
        
        self.activityIndi.stopAnimating()
        self.activityIndi.hidden  = true
     }
}
