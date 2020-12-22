//
//  FriendsViewController.swift
//  Aura
//
//  Created by necixy on 15/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController , NSURLConnectionDelegate , FriendshipStatusDelegate , UIActionSheetDelegate {
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnAllFriends: UIButton!
    @IBOutlet weak var btnInnerFriends: UIButton!
    @IBOutlet weak var clView: UICollectionView!
    var friStatus : FriendStatus = FriendStatus()
    var arrayFriendList : NSMutableArray = []
    var arrayInnerFriendList : NSMutableArray = []
    var arrayTemp : NSMutableArray = []
    var data = NSMutableData()
    var appDel : AppDelegate!
    var pageNumber : Int!
    var lastPage : Int!
    var strId: NSString!
    var isInnerCircle : Bool!
    var selectedTag : Int!
    var lastIndexOfCell : Int!
    

    
    
    @IBOutlet weak var lblNoRecordMsg: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTag = 0
        friStatus.delegate = self
        selectedTag = 0
        pageNumber = 0

        let headerView : UIView = UIView()
       
        headerView.frame=CGRectMake(70, 0, 220, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 220, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        headerLbl.text = "Friends"
        
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "pendingReq"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 32, 32)
        
        button.addTarget(self, action: "onPendingRequestButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        isInnerCircle = false
        strId = userDefault.objectForKey("userId") as? NSString
     //   lastSectionLastRow = 11


           clView!.registerNib(UINib(nibName: "FriendsCell", bundle: nil), forCellWithReuseIdentifier: "FriendsCell")
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.getAllUser()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFriendList", name: "updateUserRequest", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFriendList", name: "friendRequestUpdate", object: nil)
    }
    
    func updateFriendList()
    {
        self.getAllUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true;
    }

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtSearch .resignFirstResponder()
        
        if !txtSearch.text!.isEmpty
        {
            if isInnerCircle == true
            {
                arrayTemp = arrayInnerFriendList .mutableCopy() as! NSMutableArray
                arrayInnerFriendList .removeAllObjects()
                for var i = 0 ; i < arrayTemp.count ; i++
                {
                    let dictTemp : NSDictionary = arrayTemp.objectAtIndex(i) as! NSDictionary
                    if ((dictTemp.objectForKey("f_name") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                    {
                        arrayInnerFriendList.addObject(arrayTemp.objectAtIndex(i))
                    }
                    
                    if ((dictTemp.objectForKey("email") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                    {
                        arrayInnerFriendList.addObject(arrayTemp.objectAtIndex(i))
                    }
                
               
                }
                
//                if (arrayInnerFriendList.count <= 0)
//                {
//                    arrayInnerFriendList = arrayTemp .mutableCopy() as! NSMutableArray
//                }
//                else
//                {
                    self.clView .reloadData()
               // }
              }
            else
            {
                arrayTemp = arrayFriendList .mutableCopy() as! NSMutableArray
                arrayFriendList .removeAllObjects()
                for var i = 0 ; i < arrayTemp.count ; i++
                {
                   
                    let dictTemp : NSDictionary = arrayTemp.objectAtIndex(i) as! NSDictionary
                    if ((dictTemp.objectForKey("f_name") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                    {
                        arrayFriendList.addObject(arrayTemp.objectAtIndex(i))
                    }
                    
                    if ((dictTemp.objectForKey("email") as! String).caseInsensitiveCompare(txtSearch.text!) == NSComparisonResult.OrderedSame  )
                    {
                        arrayFriendList.addObject(arrayTemp.objectAtIndex(i))
                    }

                }
                 self.clView .reloadData()
                
//                if (arrayFriendList.count <= 0)
//                {
//                
//                    arrayFriendList = arrayTemp .mutableCopy() as! NSMutableArray
//                    
//                }
                
                
            }
           
            
            
        }
        return true;
        
    }
    @IBAction func clearTextField(sender: AnyObject) {
       
        if self.txtSearch.text!.isEmpty == false
        {
        if isInnerCircle == true
        {
            arrayInnerFriendList = arrayTemp .mutableCopy() as! NSMutableArray
            
        }
        else
        {
            arrayFriendList = arrayTemp .mutableCopy() as! NSMutableArray
            
        }
        txtSearch.text = ""
        txtSearch .resignFirstResponder()
            self.clView .reloadData()
        }
    }
    
    @IBAction func onInnerCircle(sender: AnyObject)
    {
        if(arrayTemp.count>0)
        {
            arrayFriendList = arrayTemp .mutableCopy() as! NSMutableArray
            arrayTemp .removeAllObjects()
        }
       
        txtSearch.text = ""
        txtSearch .resignFirstResponder()
       // arrayInnerFriendList .removeAllObjects()
        isInnerCircle = true
        btnInnerFriends.backgroundColor = selectedColor
        btnAllFriends.backgroundColor = appColor
        self.clView .reloadData()
        
    }
    
    @IBAction func onAllFriends(sender: AnyObject) {
        if(arrayTemp.count>0)
        {
            arrayInnerFriendList = arrayTemp .mutableCopy() as! NSMutableArray
             arrayTemp .removeAllObjects()
        }
      //  arraySelFriends .removeAllObjects()
        txtSearch.text = ""
        txtSearch .resignFirstResponder()
        isInnerCircle = false
        btnAllFriends.backgroundColor = selectedColor
        btnInnerFriends.backgroundColor = appColor
        self.clView .reloadData()
    }
    func onPendingRequestButton()
    {
        let mmVC : FriendRequestsViewController = FriendRequestsViewController(nibName : "FriendRequestsViewController" , bundle : nil)
        
        self.navigationController?.pushViewController(mmVC, animated: true)
    }
    
    
    
    func FrindsAction (sender : UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Began
        {
            selectedTag = sender.view!.tag
            // var tempDict : NSMutableDictionary!
            
            
            if isInnerCircle == true
            {
                
                self.showInneraCircleActiosheet()
                
            }
            else
            {
                if (arrayFriendList.objectAtIndex(selectedTag).objectForKey("status") as! String == "102")
                {
                    
                    let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Remove from Inner Circle", "Remove from Friends")
                    
                    actionSheet.tag = 1
                    actionSheet.showInView(self.view)
                }
                else
                {
                    
                    
                    self.showNonInneraCircleActiosheet()
                }
            }
        }
        
        
    }
    
    func showNonInneraCircleActiosheet()
    {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Add to Inner Circle", "Remove from Friends")
        actionSheet.tag = 1
        actionSheet.showInView(self.view)
    }
    
    func showInneraCircleActiosheet()
    {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Remove from Inner Circle", "Remove from Friends")
        actionSheet.tag = 2
        actionSheet.showInView(self.view)
        
    }
    
    
    // MARK: - Get All Friends List
    func getAllUser()
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
          //  MBProgressHUD .hideHUDForView(self.view, animated: true)
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {
       
        let strUrl : NSString = NSString(format: "%@user/friends/%@?page=%d",self.basicUrl() , strId!,pageNumber)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
            conn!.start()
        self.data.setData(NSData())
        }
        
    }
    

    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
       print("Error")
         globalAlertView("Please check your internet connection", viewCont: self)
        MBProgressHUD .hideHUDForView(self.view, animated: true)
    }
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
       
        do
        {
            
       let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let statusCode = jsonResult.objectForKey("status") as? NSString
        self.data.setData(NSData())
        if statusCode == "200"
        {
            
            if pageNumber == 0
            {

            }
            
            
            let array : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
            
            if array.count > 0
            {
                arrayInnerFriendList .removeAllObjects()
                arrayFriendList.removeAllObjects()
                
            for var i = 0 ; i < array.count ; i++
            {
                
                 self.lblNoRecordMsg.hidden = true
                let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                
                if dictTemp.objectForKey("status") as! String == "102"
                {
                    arrayInnerFriendList.addObject(dictTemp)
                }
                arrayFriendList.addObject(dictTemp)
                
            }
              lastIndexOfCell = (pageNumber+1)*99
           
            self.clView .reloadData()
            }
            else
            {
                
                self.lblNoRecordMsg.hidden = false
                if arrayFriendList.count > 0
                {
                    arrayInnerFriendList .removeAllObjects()
                    arrayFriendList.removeAllObjects()
                    
                }
            }
            self.clView .reloadData()
          
        }
        }
        catch
        {
            print(error)
        }
        
    }

    
    // MARK: - CollectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isInnerCircle == true
        {
            return arrayInnerFriendList.count
        }
        return arrayFriendList.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendsCell", forIndexPath: indexPath) as! FriendsCell
        cell.backgroundColor = UIColor.clearColor()
        
        var dictTempt : NSDictionary!
       
        if isInnerCircle == true
        {
          dictTempt  = arrayInnerFriendList.objectAtIndex(indexPath.row) as! NSDictionary
           // cell.imgInnerCrcl.hidden = false
        }
        else
        {
           dictTempt  = arrayFriendList.objectAtIndex(indexPath.row) as! NSDictionary
        }
        if dictTempt.objectForKey("status") as! String == "102"
        {
           cell.imgInnerCrcl.hidden = false
        }
        else
        {
             cell.imgInnerCrcl.hidden = true
        }
        
        cell.lblUserName.text = dictTempt.objectForKey("f_name") as? String
        
        if(dictTempt.objectForKey("thumb")as? String != nil)
        {
             let strUrl : NSURL = NSURL(string: dictTempt.objectForKey("thumb")  as! String)!
            
            cell.imgUser.image = UIImage(named: "userPlace")
            
            cell.imgUser.imageURL = strUrl
       
        }
        else
        
        {
            cell.imgUser.image = UIImage(named: "userPlace")
        }
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.width/2;
        cell.imgUser.layer.masksToBounds = true
        
        let longGesOnImage : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "FrindsAction:")
           cell.imgUser.tag = indexPath.row
        
        //longGesOnImage.numberOfTouches() = 1
        cell.imgUser.addGestureRecognizer(longGesOnImage)
      
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
       
        var tempDict : NSMutableDictionary!
        
        if isInnerCircle == true{
            tempDict  = arrayInnerFriendList .objectAtIndex(indexPath.row) as! NSMutableDictionary
        }
        else
        {
            tempDict  = arrayFriendList .objectAtIndex(indexPath.row) as! NSMutableDictionary
        }
        let otherUserProfileVC : OtherUserProfileViewController = OtherUserProfileViewController(nibName : "OtherUserProfileViewController" , bundle : nil)
        otherUserProfileVC.dictData = tempDict
        otherUserProfileVC.isFromSearch = false
        otherUserProfileVC.fromPendingReq = false
        otherUserProfileVC.userId = tempDict.objectForKey("friend_id") as! String
        self.navigationController?.pushViewController(otherUserProfileVC, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(93, 111)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        
        let lastIndexPath : NSIndexPath = NSIndexPath(forRow: lastIndexOfCell, inSection: 0)
        print(lastIndexPath.item)
        if indexPath.row == lastIndexPath.row
        {
            pageNumber = pageNumber + 1
            self.getAllUser()
            
        }
        
    }
    // MARK: --------------- ACTIONSHEET DELEGATE
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        
        
        switch buttonIndex{
            
        case 1:
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            if actionSheet.tag == 1
            {
                if (arrayFriendList.objectAtIndex(selectedTag).objectForKey("status") as! String == "102")
                {
                    friStatus.selected("101" , userId: arrayFriendList.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayFriendList.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
                    
                }
                else
                {
                    
                    friStatus.selected("102" , userId: arrayFriendList.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayFriendList.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
                }
            }
            else
            {
                friStatus.selected("101" , userId: arrayInnerFriendList.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayInnerFriendList.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
            }
            break;
            
        case 2:
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            if actionSheet.tag == 1
            {
                friStatus.selected("105" , userId: arrayFriendList.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayFriendList.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
            }
            else
            {
                friStatus.selected("105" , userId: arrayInnerFriendList.objectAtIndex(selectedTag).objectForKey("user_id") as! String , friendId: arrayInnerFriendList.objectAtIndex(selectedTag).objectForKey("friend_id") as! String  )
            }
            
            break;
            
        default:
            NSLog("Default");
            break;
            
        }
        
        
    }

    
    // MARK: --------------- FRIENDSHIP STATUS DELEGATE
    func statusAfterSuccess(statusCode : Int)
    {
        if (arrayInnerFriendList.count <= 0)
                       {
                           arrayInnerFriendList = arrayTemp .mutableCopy() as! NSMutableArray
                       }
        if (arrayFriendList.count <= 0)
                       {
       
                           arrayFriendList = arrayTemp .mutableCopy() as! NSMutableArray
                           
                       }

        switch (statusCode)
        {
            
        case 101:
            self.getAllUser()
            break;
        case 102:
            self.getAllUser()
            break;
        case 100 :
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            if isInnerCircle == true
            {
                arrayInnerFriendList.removeObjectAtIndex(selectedTag)
            }
            else
            {
                arrayFriendList.removeObjectAtIndex(selectedTag)
            }
            self.clView.reloadData()
            //             self.getAllUser()
            break;
        default :
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            globalAlertView("Please check your internet connection", viewCont: self)
            break;
        }
        
        
    }

}
