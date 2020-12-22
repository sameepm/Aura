//
//  OtherUserProfileViewController.swift
//  Aura
//
//  Created by necixy on 19/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class OtherUserProfileViewController: UIViewController {
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMyHpns: UILabel!
    @IBOutlet weak var btnReqPend: UIButton!
    @IBOutlet weak var imgFeeling: UIImageView!
    @IBOutlet weak var imguser: UIImageView!
    @IBOutlet weak var lblFname: UILabel!
    @IBOutlet weak var lblHappiness: UILabel!
    @IBOutlet weak var lblLname: UILabel!
    @IBOutlet weak var btnScore: UIButton!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var btnInnerCircle: UIButton!
    @IBOutlet weak var btnAddFriend: UIButton!
    var dictData : NSMutableDictionary!
    var isFromSearch : Bool!
    var data = NSMutableData()
    var appDel : AppDelegate!
    var dictMyInfo : NSDictionary!
    var friStatus : Int32!
    var userId : String!
    var hasAddedInInner : Bool!
    var hasAddedFrnd : Bool!
    var fromPendingReq : Bool!
    
    @IBOutlet weak var btnRejectFriReqRec: UIButton!
    @IBOutlet weak var lblTitleFeel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let headerView : UIView = UIView()
        hasAddedInInner = false
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 180, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 180, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        
        if isFromSearch == true
        {
            headerLbl.text = "People"
        }
        else
        {
            headerLbl.text = "Friends"
        }
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem

         appDel = UIApplication.sharedApplication().delegate as! AppDelegate
         dictMyInfo  = self.getUserData()
        lblTitleFeel.text = "I AM FEELING"
        if dictMyInfo.objectForKey("id") as? String == dictData.objectForKey("id")  as? String
        {
            btnAddFriend.hidden = true
            btnInnerCircle.hidden = true
            
          let scoreHpns : String = (userDefault.objectForKey("happinesScore") as? String)!
            btnScore.setTitle(scoreHpns, forState: UIControlState.Normal)
            
            let mood : String = userDefault.objectForKey("mymood") as! String
            lblHappiness.text = mood
            let  strBg : String  = String(format: "feeling%@.png", mood  ) as String
            imgFeeling!.image=UIImage(named: strBg)
            headerLbl.text = "My Profile"
            
        }
        else
        {
            
             self.getUserDetail()
        }
      
        if  (dictData.objectForKey("thumb")as? String != nil)
        {
             var imgStr : String!
            if isFromSearch == true
            {
               imgStr = String (format: "%@", dictData.objectForKey("thumb")  as! String )
            }
            else
            {
                 imgStr = String (format: "%@", dictData.objectForKey("thumb")  as! String )
            }
           
            let strUrl : NSURL = NSURL(string: imgStr)!
            
            imguser.image = UIImage(named: "userPlace")
            imguser.imageURL = strUrl
        
        }
        else
        {
            
            imguser.image = UIImage(named: "userPlace")
            
        }
        
        
            
       
        imguser.layer.cornerRadius = imguser.frame.size.width/2
        imguser.layer.masksToBounds = true
        
        lblFname.text = dictData.objectForKey("f_name") as? String
//     if(UIScreen .mainScreen().bounds.size.height<568)
//     {
//        scrlView.contentSize = CGSizeMake(320, 590)
//    }
        btnAddFriend.layer.cornerRadius = 5
        btnInnerCircle.layer.cornerRadius = 5
        btnReqPend.layer.cornerRadius = 5
        btnRejectFriReqRec.layer.cornerRadius = 5;
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "onBackButton")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - Get User Detail
    
    
    func getUserDetail()
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
            MBProgressHUD .hideHUDForView(self.view, animated: true)
            globalAlertView("Please check your internet connection", viewCont: self)
        }
else
        {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var strUrl : NSString!
        if isFromSearch == true
        {
              strUrl = NSString(format: "%@user/friend/%@?friend_id=%@",self.basicUrl(), (dictMyInfo.objectForKey("id")as? String)!,(dictData.objectForKey("id") as? String)!)
        }
        else
        {
            strUrl = NSString(format: "%@user/friend/%@?friend_id=%@",self.basicUrl(), (dictMyInfo.objectForKey("id")as? String)!,(dictData.objectForKey("friend_id") as? String)!)
        }
      
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
            conn!.start()
        self.data.setData(NSData())
            
        }
    }
    
    
    // MARK: - Add In Inner Circle
    @IBAction func sendRequestForInnerCircle(sender: AnyObject)
    {
        if hasAddedInInner == true
        {
            friStatus = 101
        }
        else
        {
            hasAddedInInner = false
            friStatus = 102
        }
        
      
        self.actionOnFriendRequest()
        
    }
    //MARK: - Reject From Receiver
    
    @IBAction func rejectFriendRequestFromReceiver(sender: AnyObject) {
        friStatus = 104
        self.actionOnFriendRequest()
    }
    // MARK: - Confirm Friend Request
    
    @IBAction func confirmFriendRequest(sender: AnyObject) {
        friStatus = 101
        self.actionOnFriendRequest()
 

    }
    
   // MARK: - Add Friend
    @IBAction func serdRequestForAddFriend(sender: AnyObject) {
        
        if hasAddedInInner == false
        {
            if( hasAddedFrnd == true )
            {
                 friStatus = 105
            }
            else
            {
                if friStatus == 100
                {
                    friStatus = 100
                }
                else
                {
                friStatus = 0
                }

            }
           
        }
        else
        {
            if dictData .objectForKey("status") as! String == "100"
            {
             friStatus = 103
            }
            else if dictData .objectForKey("status") as! String == "102"
            {
               friStatus = 105
            }
            else
            {
                
            }
           
        }
        self.actionOnFriendRequest()
        
            }
   // MARK: - Action On Friend Request 
    
    func actionOnFriendRequest()
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {

          MBProgressHUD.showHUDAddedTo(self.view, animated: true)
         var request : ASIFormDataRequest?
        switch (friStatus)
        {
            
        case 0 :
            let strUrl : NSString = NSString(format: "%@user/friend/add/%@",self.basicUrl(),(dictMyInfo.objectForKey("id") as? String)!)
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            
            break ;
            
            
        case 100 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),(dictMyInfo.objectForKey("id") as? String)!)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("103", forKey: "status")
            request?.setPostValue((dictData.objectForKey("friend_id") as? String)!, forKey: "friend_id")
        
            
            break ;
            
        case 101 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),(dictMyInfo.objectForKey("id") as? String)!)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("101", forKey: "status")
            request?.setPostValue((dictData.objectForKey("friend_id") as? String)!, forKey: "friend_id")
            
            break ;

            
         
        case 102 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),(dictMyInfo.objectForKey("id") as? String)!)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("102", forKey: "status")
            request?.setPostValue((dictData.objectForKey("friend_id") as? String)!, forKey: "friend_id")
            
            break ;
            
        case 104 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),(dictMyInfo.objectForKey("id") as? String)!)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("104", forKey: "status")
             request?.setPostValue((dictData.objectForKey("friend_id") as? String)!, forKey: "friend_id")
            break ;
        case 105 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),(dictMyInfo.objectForKey("id") as? String)!)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("105", forKey: "status")
            request?.setPostValue((dictData.objectForKey("friend_id") as? String)!, forKey: "friend_id")
            friStatus = 104
            break;

        default :
            break ;
        }
        
        request?.delegate=self
        request?.setPostValue((dictData.objectForKey("friend_id") as? String)!, forKey: "friend_id")
        request?.startAsynchronous()
        }
        
    }
    
    
    
    // MARK: - NSURL Connection Delegate
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // println("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
            do{
        if let jsonResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) {
            
                let statusCode = jsonResult.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                    dictData = (jsonResult.objectForKey("details") as? NSMutableDictionary)!
                    let  friendStatus : AnyObject =  dictData.objectForKey("status")!
                   
                   friStatus = friendStatus.intValue
                   // }
                    btnAddFriend.hidden = false
                    switch (friStatus)
                    {
                        
                    case 99 :
                        // btnInnerCircle.hidden = false
                        btnReqPend.hidden=false
                        btnAddFriend.hidden = true
                        btnRejectFriReqRec.hidden=false
                        btnRejectFriReqRec.setTitle("Not Now", forState: UIControlState.Normal)
                        
                        break ;

                  
                    case 100 :
                       // btnInnerCircle.hidden = false
                        btnAddFriend .setTitle("Delete friend request", forState:UIControlState.Normal)
                        btnAddFriend.backgroundColor = UIColor.redColor()
                        hasAddedInInner = false
                        hasAddedFrnd = false
                        break ;
                        
                    case 101 :
                        btnInnerCircle.hidden = false
                        btnInnerCircle.setTitle("Add to Inner Circle", forState: UIControlState.Normal)
                        btnAddFriend .setTitle("Remove from Friends", forState:UIControlState.Normal)
                        
                        btnAddFriend.backgroundColor = UIColor.redColor()
                        hasAddedInInner = false
                        hasAddedFrnd = true
                        friStatus = 105
                        
                        break ;
                    case 102 :
                        btnInnerCircle.hidden = false
                        btnAddFriend .setTitle("Remove from Friends", forState:UIControlState.Normal)
                        btnAddFriend.backgroundColor = UIColor.redColor()
                        btnInnerCircle.backgroundColor = UIColor.redColor()
                          btnInnerCircle .setTitle("Remove from Inner Circle", forState:UIControlState.Normal)
                        hasAddedInInner = true
                        hasAddedFrnd = true
                        break ;

                    

                    default :
                        btnInnerCircle.hidden = true
                        btnAddFriend .setTitle("Add as Friend", forState:UIControlState.Normal)
                        hasAddedFrnd = false
                        hasAddedInInner = false
                        break ;
                        
                    }
                    
//                    if (dictData.objectForKey("mood")as? String != nil)
//                    {
//                    var moodStr  : String =  String (format: "%@", (dictData.objectForKey("mood") as! NSString))
//                        let score : String = String (format: "%@", (dictData.objectForKey("score") as! NSString))
//                       // btnScore.setTitle(score, forState: UIControlState.Normal)
//                        
//                    if moodStr == "0"
//                    {
//                        lblHappiness.textColor = UIColor.blackColor()
//                       // lblFeelTitle.textColor = UIColor.blackColor()
//                    }
//                    let moodScal : Int  = Int(moodStr)!
//                    moodStr = appDel.getScoreOfHappiness(moodScal)
//                   
//                    moodStr = appDel.moodAccordinghappinesScore(moodScal)
//                    lblHappiness.text = moodStr as String
//                    
//                    let  strBg : String  = String(format: "feeling%@.png", moodStr  ) as String
//                    imgFeeling!.image=UIImage(named: strBg)
//                    }
//                    else
//                    {
//                       // lblHappiness.text = "NA"
//                      //   btnScore.setTitle("NA", forState: UIControlState.Normal)
//                       // lblHappiness.textColor = UIColor.blackColor()
//                        // lblTitleFeel.textColor = UIColor.blackColor()
//                      //  btnScore.titleLabel?.textColor = UIColor.blackColor()
////                        lblHappiness.textColor  = UIColor.blackColor()
////                        lblScore.textColor = UIColor.blackColor()
////                         let imgStr : String = "placeHolder.png"
////                        imgFeeling.image = UIImage (named: imgStr)
//                    }

                    
                }
            }
        }
        catch
        {
            print(error)
        }
        
        
    }

   
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let response = request.responseString()
        print(response)
        
        do {
        let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
        
        if let aStatus = jsonObject as? NSDictionary{
            let statusCode = aStatus.objectForKey("status") as? NSString
            if statusCode == "200"
            {
                print("Success")
                
                let sendReq : Bool = (aStatus.objectForKey("success") as? Bool)!
                    if sendReq  == true
                    {
                        switch (friStatus )
                        {
                       
                        case 0 :
                        btnAddFriend .setTitle("Delete friend request", forState: UIControlState.Normal)
                        btnAddFriend.backgroundColor = UIColor.redColor()
                        hasAddedInInner = false
                        hasAddedFrnd = false
                        friStatus = 100
                        break;
                            
                        case 100 :
                            btnRejectFriReqRec.hidden = true
                            btnAddFriend .setTitle("Add as Friend", forState: UIControlState.Normal)
                            btnAddFriend.backgroundColor = appColor
                            hasAddedInInner = false
                            hasAddedFrnd = false
                            dictData .setObject("0", forKey: "status")
                            friStatus = 0
                            break;
                            
                            
                        case 101 :
                            
                            btnRejectFriReqRec.hidden = true
                            btnAddFriend .setTitle("Remove from Friends", forState: UIControlState.Normal)
                           
                            btnAddFriend.backgroundColor = UIColor.redColor()
                            btnInnerCircle.setTitle("Add to Inner Circle", forState: UIControlState.Normal)
                            btnInnerCircle.backgroundColor = appColor
                            btnReqPend.hidden = true
                            btnRejectFriReqRec.hidden = true
                            btnInnerCircle.hidden = false
                            btnAddFriend.hidden = false
                            hasAddedInInner = false
                            hasAddedFrnd = true
                
                            break ;
                            
                            case 102 :
                            btnRejectFriReqRec.hidden = true
                            btnInnerCircle.setTitle("Remove from Inner Circle", forState: UIControlState.Normal)
                            btnInnerCircle.backgroundColor = UIColor.redColor()
                            btnAddFriend .setTitle("Remove from Friends", forState: UIControlState.Normal)
                            dictData .setObject("102", forKey: "status")
                            btnAddFriend.backgroundColor = UIColor.redColor()
                            hasAddedInInner = true
                            hasAddedFrnd = true
                           
                            break ;
                        case 103 :
                            btnAddFriend .setTitle("Add as Friend", forState: UIControlState.Normal)
                            btnRejectFriReqRec.hidden = true
                            btnAddFriend.backgroundColor = appColor
                            hasAddedInInner = false
                            hasAddedFrnd = false
                            friStatus = 0
                             dictData .setObject("0", forKey: "status")
                            break;
                            
                        case 104 :
                            
                            
                            btnAddFriend .setTitle("Add as Friend", forState: UIControlState.Normal)
                            btnAddFriend.backgroundColor = appColor
                            
                            btnReqPend.hidden = true
                            btnAddFriend.hidden = false
                            btnInnerCircle.hidden = true
                            friStatus = 0
                            btnRejectFriReqRec.hidden = true
                            hasAddedInInner = false
                            hasAddedFrnd = false
                             dictData .setObject("0", forKey: "status")
                            
                            
                            break ;


                        default :
                            break;
                        }
                    }
                
                if fromPendingReq == true
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateUserPendingRequest", object: nil)
                }
                else
                {
                NSNotificationCenter.defaultCenter().postNotificationName("updateUserRequest", object: nil)
                }
                
            }
            else
            {
               
            }
            
        }
        }
            catch
            {
                print(error)
            }
        
        
    }
    
    func requestFailed( req : ASIHTTPRequest ){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
        print(req.error)
    }

}
