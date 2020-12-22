//
//  FriendRequestsViewController.swift
//  Aura
//
//  Created by necixy on 28/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class FriendRequestsViewController: UIViewController ,SlideNavigationControllerDelegate   {
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnCleaqrField: UIButton!
    var dictData : NSMutableDictionary!
    @IBOutlet weak var lblNoReq: UILabel!
    var data = NSMutableData()
    var arrayFriendsReq : NSMutableArray = []
    var arrayFriendsReqTemp : NSMutableArray = []
    @IBOutlet weak var tblFriendReq: UITableView!
    var dictMyInfo : NSDictionary!
    var appDel : AppDelegate!
    var buttontag : Int!
    var isAccept : Bool!
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
        headerLbl.text="Friends Request"
        headerLbl.minimumScaleFactor = 0.5
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let left:UIBarButtonItem = UIBarButtonItem()
        left.customView = button
        self.navigationItem.leftBarButtonItem = left
        
        
        
        
        //--------------- Navigation Buttons
        let buttonAddFrnd: UIButton = UIButton()
        buttonAddFrnd.setImage(UIImage(named: "addFriend"), forState: .Normal)
        buttonAddFrnd.frame = CGRectMake(5, 5, 34, 24)
        
        buttonAddFrnd.addTarget(self, action: "onAddButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = buttonAddFrnd
        self.navigationItem.rightBarButtonItem = rightItem

        
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        dictMyInfo  = self.getUserData()
        self.tblFriendReq.tableFooterView = UIView(frame: CGRectZero)
        self.getAllFriendsRequest()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList", name: "updateUserPendingRequest", object: nil)
        //updateUserPendingRequest
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// MARK: - Action On Buttons
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actionOnClearField(sender: AnyObject) {
        arrayFriendsReq = arrayFriendsReqTemp .mutableCopy() as! NSMutableArray
        
        txtSearch.text = ""
        self.tblFriendReq.reloadData()
    }
    func onAddButton()
    {
        let searchFriend : SearchFriendsViewController = SearchFriendsViewController(nibName : "SearchFriendsViewController" , bundle : nil)
        
        self.navigationController?.pushViewController(searchFriend, animated: true)
    }

    
// MARK: - Update Friend list
    func updateList()
    {
         self.getAllFriendsRequest()
    }
    
   
  
    
    func getAllFriendsRequest()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let strUrl : NSString = NSString(format: "%@user/friends/requests/received/%@?page=0",self.basicUrl(), (dictMyInfo.objectForKey("id")as? String)!)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
        conn!.start()
        self.data.setData(NSData())
    }
    
// MARK: - Action On Request
    func friendRequestAccept( sender: UIButton)
    {
         let button = sender as UIButton
        
        buttontag = button.tag
        isAccept = true
       //        let indexPth = NSIndexPath(forRow:buttontag, inSection: 0)
      //        let cell = self.tblFriendReq.cellForRowAtIndexPath(indexPth) as! FriendReqCell
          self.actionOnFriendRequest()
        
    }
    
    func friendRequestDecline( sender: UIButton)
    {
        let button = sender as UIButton
        
        buttontag = button.tag
        isAccept = false
        self.actionOnFriendRequest()
        
    }
    
    func actionOnFriendRequest()
    {
        dictData = arrayFriendsReq.objectAtIndex(buttontag) as! NSMutableDictionary
        
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var request : ASIFormDataRequest?
        let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),(dictMyInfo.objectForKey("id") as? String)!)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        
        
        request = ASIFormDataRequest(URL:searchURL as NSURL)
        request?.delegate=self
        
        if isAccept == true
        {
           request?.setPostValue("101", forKey: "status")
        }
        else
        {
            request?.setPostValue("104", forKey: "status")
        }
        
        request?.setPostValue((dictData.objectForKey("friend_id") as? String)!, forKey: "friend_id")
        request?.startAsynchronous()
    }
// MARK: - ASIHTTPRequest
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      
        do
        {
        let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
        
        if let aStatus = jsonObject as? NSDictionary{
            let statusCode = aStatus.objectForKey("status") as? NSString
            if statusCode == "200"
            {
                print("Success")
                
                let sendReq : Bool = (aStatus.objectForKey("success") as? Bool)!
                if sendReq  == true
                {
                    arrayFriendsReq.removeObjectAtIndex(buttontag)
                    self.tblFriendReq .reloadData()
                }
                
                if(arrayFriendsReq.count <= 0 )
                {
                    self.lblNoReq.hidden = false
                }
                  NSNotificationCenter.defaultCenter().postNotificationName("friendRequestUpdate", object: nil)
                //friendRequestUpdate
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
             do
        {
        if let jsonResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) {
         
                let statusCode = jsonResult.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                    let array : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
                    if array.count > 0
                    {
                         self.lblNoReq.hidden = true
                        arrayFriendsReq.removeAllObjects()
                        
                      for var i = 0 ; i < array.count ; i++
                      {
                        let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                        arrayFriendsReq.addObject(dictTemp)
                        
                      }
                    }
                    else
                    {
                        self.lblNoReq.hidden = false
                        if arrayFriendsReq.count > 0
                        {
                            arrayFriendsReq.removeAllObjects()
                        }
                    }
                    
                    self.tblFriendReq .reloadData()
                       NSNotificationCenter.defaultCenter().postNotificationName("friendRequestUpdate", object: nil)
                }
           
        }
        }
        catch
        {
            print(error)
        }
        
        
    }
    
// MARK: - Tableview Method

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return arrayFriendsReq.count
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                   return 110.0;
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let identifier = "Custom"
            var cell: FriendReqCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? FriendReqCell
            
            if cell == nil {
                tableView.registerNib(UINib(nibName: "FriendReqCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? FriendReqCell
            }
        let dictTemp : NSDictionary  = arrayFriendsReq.objectAtIndex(indexPath.row) as! NSDictionary
        
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width/2
        cell.imgUser.layer.masksToBounds=true
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        cell.lbluserName.text = dictTemp.objectForKey("f_name") as? String
            
        if  dictTemp.objectForKey("thumb") as? NSObject != NSNull() ||  dictTemp.objectForKey("thumb") as? String == nil
        {
            if dictTemp.objectForKey("thumb") as? String == nil
            {
                cell.imgUser.image = UIImage(named: "userPlace")
            }
            else
            {
            let imgStr : String = String (format: "%@", dictTemp.objectForKey("thumb")  as! String )
            let strUrl : NSURL = NSURL(string: imgStr)!
                
                cell.imgUser.imageURL = strUrl
                cell.imgUser.image = UIImage(named: "userPlace")

            }
        }
        cell.backgroundColor=UIColor .clearColor()
        cell.btnAccept .addTarget(self, action: "friendRequestAccept:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.btnReject .addTarget(self, action: "friendRequestDecline:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.None

                            // println("%@",section())
                return cell
        }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tempDict : NSMutableDictionary = arrayFriendsReq.objectAtIndex(indexPath.row) as! NSMutableDictionary
        let otherUserProfileVC : OtherUserProfileViewController = OtherUserProfileViewController(nibName : "OtherUserProfileViewController" , bundle : nil)
        otherUserProfileVC.dictData = tempDict
        otherUserProfileVC.fromPendingReq = true
        otherUserProfileVC.isFromSearch = false
      otherUserProfileVC.userId = tempDict.objectForKey("user_id") as! String
        
        self.navigationController?.pushViewController(otherUserProfileVC, animated: true)
        
    }
    
// MARK: - TextFiled Delegate Methode
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtSearch .resignFirstResponder()
        self.searchResult()
        return true;
        
    }
    
// MARK: - Searching
    
    func searchResult()
    {
        arrayFriendsReqTemp = arrayFriendsReq .mutableCopy() as! NSMutableArray
        arrayFriendsReq.removeAllObjects()
        for var i = 0 ; i < arrayFriendsReqTemp.count ; i++
        {
            let dict : NSDictionary = arrayFriendsReqTemp.objectAtIndex(i) as! NSDictionary
            let string : String = dict.objectForKey("f_name") as! String
            if (string.caseInsensitiveCompare(txtSearch.text! as String) == NSComparisonResult.OrderedSame)
            {
                arrayFriendsReq.addObject(arrayFriendsReqTemp.objectAtIndex(i))
            }
            
        }
        
        
        self.tblFriendReq.reloadData()
        
        if(arrayFriendsReq.count <= 0)
        {
            arrayFriendsReq = arrayFriendsReqTemp .mutableCopy() as! NSMutableArray
        }
        
    }
    
 

}
        // Configure the cell...
        
   