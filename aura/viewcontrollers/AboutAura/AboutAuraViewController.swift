//
//  AboutAuraViewController.swift
//  Aura
//
//  Created by Apple on 28/11/15.
//  Copyright © 2015 necixy. All rights reserved.
//

import UIKit
import MessageUI

class AboutAuraViewController: UIViewController , MFMailComposeViewControllerDelegate , SlideNavigationControllerDelegate  {

    @IBOutlet var viewAllContent: UIView!
    @IBOutlet var scrlView: UIScrollView!
   
    @IBOutlet var btnFeedback: UIButton!
    
    @IBOutlet var txtView: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let headerView : UIView = UIView()
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 220, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 220, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        headerLbl.text="About Aura"
        headerLbl.minimumScaleFactor = 0.5
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
      //  self.scrlView.zooming = 1.0
     
        scrlView.maximumZoomScale = 4.0
        scrlView.minimumZoomScale = 1.0

        if (UIScreen.mainScreen().bounds.size.height < 500)
        {
           scrlView.contentSize = CGSizeMake(320, 518)
        }
        else
        {
              scrlView.contentSize = CGSizeMake(320, 400)
        }
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// MARK: --------------- SlideNavigationController
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        
        return true
    }
// MARK: --------------- Scroll Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.viewAllContent
    }
// MARK: --------------- MFMAIL COMPOSER DELEGATE

@IBAction func providingFeedbackOfAuraApp(sender: AnyObject) {
        let emailTitle = "Aura Feedback"
        let messageBody = "Please Provide Your Feedback"
        let toRecipents = ["feedback@aura-app.me"]
    //feedback@aura-app.me
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved:
            NSLog("Mail saved")
        case MFMailComposeResultSent:
            NSLog("Mail sent")
        case MFMailComposeResultFailed:
            NSLog("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}


