//
//  MoodsSubViewController.swift
//  Aura
//
//  Created by necixy on 23/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class MoodsSubViewController: UIViewController , SlideNavigationControllerDelegate , NSURLConnectionDelegate  {
    @IBOutlet weak var btnScore: UIButton!
    @IBOutlet weak var lblFeelTitle: UILabel!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var btnChangeMood: UIButton!
    @IBOutlet weak var btnShareMood: UIButton!
    @IBOutlet weak var lblFeeling: UILabel!
    var headerLbl : UILabel!
    var appDel : AppDelegate!
    var mood : NSString!
     var strId: NSString!
     var scale: NSString!
     var data = NSMutableData()
    var moodValue : String!
    
    @IBOutlet weak var moodBg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let headerView : UIView = UIView()
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 220, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        headerLbl = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 220, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        
        
       headerLbl.text = userDefault.objectForKey("mymood") as? String
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        let scoreHpns: String? = userDefault.objectForKey("happinesScore") as? String
         btnScore.setTitle(scoreHpns, forState: UIControlState.Normal)
        
        NSLog("ScrollView =%@",scrlView)
        if UIScreen.mainScreen().bounds.size.height < 568
        {
         scrlView.contentSize=CGSizeMake(320, 603)
        }
        else
        {
             scrlView.contentSize=CGSizeMake(320, 508)
        }
        btnChangeMood.layer.cornerRadius=2.0
        btnChangeMood.layer.masksToBounds=true
        btnShareMood.layer.cornerRadius=2.0
        btnShareMood.layer.masksToBounds=true;
        
        strId = userDefault.objectForKey("userId") as? NSString
        mood = userDefault.objectForKey("mymood") as? NSString
        
        
        
        if(mood != nil)
        {
        lblFeeling.text = mood as String
        
        let  strBg : String  = String(format: "feeling%@.png", mood  ) as String
            
            moodBg!.image=UIImage(named: strBg)
        }
       
       if scale != nil
        {
        self.postHappiness()
        }
        else
        {
    
        self.getHappinessScore()
        }
        
        NSLog("Height Of View =%.0f", UIScreen.mainScreen().bounds.size.height);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true;
    }
    
    // MARK: - Buttons Methodes
    
       
    @IBAction func onButtonAction(sender: AnyObject) {
        if (moodValue == nil)
        {
            globalAlertView("Please try again later.", viewCont: self)
        }
        else
        {
        let buttonTag : Int = sender.tag as Int
      
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let mmVC : MultiMediaViewController = MultiMediaViewController(nibName : "MultiMediaViewController" , bundle : nil)
            mmVC.moodType = self.moodValue
            mmVC.mmType = buttonTag
            self.navigationController?.pushViewController(mmVC, animated: true)
        }
        }
        
    }
    
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func detailOfMood(sender: AnyObject) {
        let moodVC : HappinesScoreViewController = HappinesScoreViewController(nibName : "HappinesScoreViewController" , bundle : nil)
     
        self.navigationController?.pushViewController(moodVC, animated: true)
    }
    @IBAction func changeMoodTapped(sender: AnyObject)
    {
        if (scale != nil)
        {
        self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            let moodSelectionVC : MoodsViewController = MoodsViewController(nibName : "MoodsViewController" , bundle : nil)
            self.navigationController?.pushViewController(moodSelectionVC, animated: true)

            
        }
        
    }
     // MARK: - Share With Friends
    
    @IBAction func shareMoodTapped(sender: AnyObject) {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let shareFrendsVC : ShareMoodViewController = ShareMoodViewController(nibName : "ShareMoodViewController" , bundle : nil)
            shareFrendsVC.shareData = self.moodValue
            shareFrendsVC.viewFromCome = "Share Mood"
            self.navigationController?.pushViewController(shareFrendsVC, animated: true)
        }
        
        
        
    }
    // MARK: - Post Happines
    func postHappiness()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // txtField.resignFirstResponder()
      
        if scale == nil
        {
            scale = "11" ;
        }
       let dict = [
            "scale": scale,
            "user_id": strId
        ]
        
        do {
       // let data = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
            let data = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
         
        
            let json = NSString(data: data, encoding: NSUTF8StringEncoding)
            if let json = json {
                var request : ASIFormDataRequest?
                let strUrl : NSString = NSString (format:"%@happiness",self.basicUrl())
                
                let searchURL : NSURL = NSURL(string: strUrl as String)!
                
                request = ASIFormDataRequest(URL:searchURL as NSURL)
                request?.delegate=self
                
                request?.setPostValue(json, forKey: "data")

                request?.startAsynchronous()
               
            }
       
        }
        
        catch {
            print(error)
        }
    }
    
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    
     //   println(response)
        
        do {
           
       // let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let statusCode = jsonObject.objectForKey("status") as? NSString
            if statusCode == "200"
            {
               // println("Success")
                
                let scoreHpns: String? = jsonObject.objectForKey("score") as? String
               userDefault.setObject(scoreHpns, forKey: "happinesScore")
               userDefault.synchronize()
            
                btnScore.setTitle(scoreHpns, forState: UIControlState.Normal)
                
                 self.getHappinessScore()
               
               
            }
            else
            {
                //globalAlertView("Email or password is wrong.", viewCont: self)
            }
            
       
        }
        
        catch {
            print(error)
        }
    }
    
    func requestFailed( req : ASIHTTPRequest ){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
       // println(req.error)
    }
    
    
   // MARK: - Get Happiness Score For User
    func getHappinessScore()
    {
        let strUrl : NSString = NSString(format: "http://api.aura-app.me/happiness/%@?page=0",strId!)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        connection.start()
          self.data.setData(NSData())
    }
        
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
       // println("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        //println(self.data)
      do {
        
      if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
        let statusCode = jsonResult.objectForKey("status") as? NSString
        if statusCode == "200"
        {
           // appDel.arrHappiness!.removeAllObjects()
            //Shashi: Comment due to crash Could not cast value of type '__NSArrayI' to 'NSMutableArray'
//            appDel.arrHappiness = (jsonResult.objectForKey("details") as? NSMutableArray)!;
            appDel.arrHappiness = (jsonResult.objectForKey("details")?.mutableCopy() as! NSMutableArray)
            if appDel.arrHappiness.count == 0
            {
                self.navigationController?.pushViewController(welcomeVC, animated: true)
            }
            else
            {
                let  tempDict : NSDictionary = appDel.arrHappiness.objectAtIndex(0) as! NSDictionary
                var mood  : String =  String (format: "%@", (tempDict.objectForKey("scale") as! NSString))
                
                if mood == "0"
                {
                    lblFeeling.textColor = UIColor.blackColor()
                    lblFeelTitle.textColor = UIColor.blackColor()
                }
                let moodScal : Int  = Int(mood)!
                mood = appDel.getScoreOfHappiness(moodScal)
                moodValue = mood
                
                userDefault.setObject(moodValue, forKey: "moodValue")
                mood = appDel.moodAccordinghappinesScore(moodScal)
                
                lblFeeling.text = mood as String
                headerLbl.text=mood as String!
                
                let  strBg : String  = String(format: "feeling%@.png", mood  ) as String
                moodBg!.image=UIImage(named: strBg)
                userDefault.setObject(mood, forKey:"mymood")
                
                if(mood == "Suicidal")
                {
                    
                  //  let attributedString = NSAttributedString(string: "", attributes: [
//                        NSFontAttributeName : UIFont.systemFontOfSize(15), //your font here,
//                        NSForegroundColorAttributeName : UIColor.redColor()
//                        ])
                    
                    
                    let alertController = UIAlertController(title: "Aura", message: "Please get help.  Life is precious!.", preferredStyle: .Alert)
                  
                    let okAction: UIAlertAction = UIAlertAction(title: "Call Hotline", style: UIAlertActionStyle.Destructive) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        if let url = NSURL(string: "tel://18002738255") {
                            UIApplication.sharedApplication().openURL(url)
                        }
                    }
                    
            //alertController.view.tintColor = UIColor.redColor()
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                     self.presentViewController(alertController, animated: true, completion: nil)
                    
                }

            }
            }
            }
        }
      catch {
        print(error)
        }
     
    }
    
    

}
