//
//  HappinesScoreViewController.swift
//  Aura
//
//  Created by necixy on 25/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class HappinesScoreViewController: UIViewController , SlideNavigationControllerDelegate {
    
    @IBOutlet var viewTemp2: UIView!
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnTrack: UIButton!
    @IBOutlet weak var viewTemp: UIView!
    @IBOutlet weak var btnHappinesScore: UIButton!
    @IBOutlet weak var lblSeekHelp: UILabel!
    @IBOutlet weak var viewSmily: UIView!
    @IBOutlet weak var btnCallHotLine: UIButton!
    @IBOutlet weak var btnTriangle: UIButton!
    @IBOutlet weak var imgThrmo: UIImageView!
   
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
        headerLbl.text="Happiness Scale"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
       
        
        btnAbout.layer.cornerRadius=2.0
        btnAbout.layer.masksToBounds=true
        btnTrack.layer.cornerRadius=2.0
        btnTrack.layer.masksToBounds=true;
        
       
        
        if appDelegate.isInLeft == false
        {
            
             self.navigationItem.leftBarButtonItem = rightItem
        }
        
        if UIScreen.mainScreen().bounds.size.height < 500
        {
            scrlView.contentSize = CGSizeMake(320, 500)
        }
        
        var scoreHpns : String!
        scoreHpns = userDefault.objectForKey("happinesScore") as? String
        
        let numberFormatter1 = NSNumberFormatter()
        let number1 : NSNumber = numberFormatter1.numberFromString(scoreHpns!)!
        
        
        
        let numberFormatter = NSNumberFormatter()
        let number : NSNumber = numberFormatter.numberFromString(scoreHpns!)!
        
        var rectTmp : CGRect = viewTemp.frame as CGRect
        
        let viewH : CGFloat = (rectTmp.size.height )/9
        let multi : CGFloat = (number as CGFloat * viewH) - viewH
        
        let hgh : CGFloat = rectTmp.size.height

        
        let scor : CGFloat = number1 as CGFloat
        
        
        
        if scor < 0
        {
            btnCallHotLine.hidden=false
            btnTriangle.hidden=false
            lblSeekHelp.hidden=false
            btnHappinesScore.hidden=true
            viewSmily.hidden=true
            imgThrmo.image=UIImage(named: "breakThrmo")
            viewTemp.hidden=true
            viewTemp2.hidden = true
            btnTriangle.setTitle(scoreHpns, forState: UIControlState.Normal)
            self.scrlView.frame = CGRectMake(0, 152, 320, 430)
        }
        else
        {
            
            btnCallHotLine.hidden=true
            btnTriangle.hidden=true
            lblSeekHelp.hidden=true
            btnHappinesScore.hidden=false
            viewSmily.hidden=false
            btnHappinesScore.setTitle(scoreHpns, forState: UIControlState.Normal)
            
            
            if scor < 1
            {
                imgThrmo.image = UIImage(named: "thrmo_Empty1")
                viewTemp.hidden = true
                viewTemp2.hidden = false
                if scor == 0
                {
                    viewTemp2.hidden = true
                }
                var rectTmp1 : CGRect = viewTemp2.frame as CGRect
                
                let viewH1 : CGFloat = (rectTmp1.size.height )/10
                
                let multi1 : CGFloat = (number as CGFloat * viewH1 * 10) - viewH1
                
                let hgh1 : CGFloat = rectTmp1.size.height
                
                rectTmp1.size.height = multi1 as CGFloat
                rectTmp1.origin.y =  rectTmp1.origin.y + (hgh1 - multi1 as CGFloat )
                viewTemp2.frame = rectTmp1
                
            }

          
            
        }

        
        if scor < 10
        {
            
       
         rectTmp.size.height = multi as CGFloat
         rectTmp.origin.y =  rectTmp.origin.y + (hgh - multi as CGFloat )
            
            
         }
        
        viewTemp.frame = rectTmp
    

        // Do any additional setup after loading the view.
    }

    @IBAction func callHotLineNumber(sender: AnyObject) {
        if let url = NSURL(string: "tel://18002738255") {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        if appDelegate.isInLeft == true
        {
           return true;
        }
        else
        {
            return false;
        }
       
    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func showMyMoods(sender: AnyObject) {
       // globalAlertView("Under Development!!", viewCont: self)
       let recordVC : TrackMoodsViewController = TrackMoodsViewController(nibName : "TrackMoodsViewController" , bundle : nil)
     
       self.navigationController?.pushViewController(recordVC, animated: true)
    }

    @IBAction func myScaleInfo(sender: AnyObject) {
        
        let scaleInfoVC : AboutMyScaleViewController = AboutMyScaleViewController(nibName : "AboutMyScaleViewController" , bundle : nil)
        
        self.navigationController?.pushViewController(scaleInfoVC, animated: true)
    }
}
