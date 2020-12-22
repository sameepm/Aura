//
//  AboutMyScaleViewController.swift
//  Aura
//
//  Created by necixy on 13/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class AboutMyScaleViewController: UIViewController {

    @IBOutlet var txtView: UITextView!
    @IBOutlet var scrlView: UIScrollView!
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
        headerLbl.text="About My Scale"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "onBackButton")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        scrlView.maximumZoomScale = 4.0
        scrlView.minimumZoomScale = 1.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: --------------- Scroll Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return self.txtView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
